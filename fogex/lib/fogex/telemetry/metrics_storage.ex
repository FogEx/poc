defmodule FogEx.Telemetry.MetricsStorage do
  use GenServer

  import Ecto.Query

  alias FogEx.Models.Metric
  alias FogEx.Repo

  require Logger

  def metrics_history(metric, timeout \\ 60_000) do
    GenServer.call(__MODULE__, {:data, metric}, timeout)
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(metrics) do
    Process.flag(:trap_exit, true)

    for metric <- metrics do
      log_debug("Starting the storage of metric #{inspect(metric.name)}")

      attach_handler(metric)
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
    metric = map_metric(data, metric_name)

    {:ok, _} = metric |> Metric.changeset() |> Repo.insert()

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
    name = metric_name_as_string(metric_name)
    node = node_as_string()
    query = from(Metric, where: [name: ^name, node: ^node])

    Repo.all(query)
  end

  defp map_metric(data, metric_name) do
    data
    |> Map.put_new(:node, node_as_string())
    |> Map.put_new(:name, metric_name_as_string(metric_name))
    |> Map.update(:time, nil, fn time -> DateTime.from_unix!(time, :microsecond) end)
  end

  defp metric_name_as_string(metric_name) do
    metric_name
    |> Enum.map_join(".", &Atom.to_string/1)
  end

  defp node_as_string do
    node() |> Atom.to_string()
  end

  defp log_debug(message) do
    Logger.debug("[#{__MODULE__}] #{message}")
  end
end
