defmodule FogEx.Telemetry.MetricsStorage do
  use GenServer

  require Logger

  def metrics_history(metric) do
    GenServer.call(__MODULE__, {:data, metric})
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(metrics) do
    Process.flag(:trap_exit, true)

    :ets.new(:metrics, [:named_table, :public, :set, {:write_concurrency, true}])

    for metric <- metrics do
      log_debug("Starting the storage of metric #{inspect(metric.name)}")

      attach_handler(metric)
      :ets.insert(:metrics, {metric.name, []})
    end

    {:ok, metrics}
  end

  @impl true
  def terminate(_, metrics) do
    for metric <- metrics do
      :telemetry.detach({__MODULE__, metric, self()})
    end

    :ok
  end

  def handle_event(_event_name, data, metadata, metric) do
    if data = Phoenix.LiveDashboard.extract_datapoint_for_metric(metric, data, metadata) do
      GenServer.cast(__MODULE__, {:telemetry_metric, data, metric.name})
    end
  end

  @impl true
  def handle_cast({:telemetry_metric, data, metric_name}, state) do
    history = lookup_metrics_history(metric_name)

    data = Map.put_new(data, :node, node())

    :ets.insert(:metrics, {metric_name, [data | history]})

    {:noreply, state}
  end

  @impl true
  def handle_call({:data, metric}, _from, state) do
    log_debug("Requested data of metric #{inspect(metric.name)}: #{inspect(metric)}")

    history = lookup_metrics_history(metric.name)

    if history do
      log_debug("Found data of metric #{inspect(metric.name)}")

      {:reply, history, state}
    else
      log_debug("Not found data of metric #{inspect(metric.name)}")

      {:reply, [], state}
    end
  end

  defp attach_handler(%{event_name: event_name} = metric) do
    :telemetry.attach(
      {__MODULE__, metric, self()},
      event_name,
      &__MODULE__.handle_event/4,
      metric
    )
  end

  defp lookup_metrics_history(metric_name) do
    metrics_history = :ets.lookup(:metrics, metric_name)

    case metrics_history do
      [{_key, data}] -> data
      _ -> []
    end
  end

  defp log_debug(message) do
    Logger.debug("[#{__MODULE__}] #{message}")
  end
end
