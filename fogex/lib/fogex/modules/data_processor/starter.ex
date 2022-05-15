defmodule FogEx.Modules.DataProcessor.Starter do
  use GenServer

  alias FogEx.Modules.DataProcessor.Supervisor, as: DataProcessorSupervisor

  require Logger

  def start_link([module: module, name: name] = opts) do
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @impl true
  def init([module: module, name: _name] = opts) do
    {:ok, opts, {:continue, {:start_and_monitor, module, 1}}}
  end

  @impl true
  def handle_continue({:start_and_monitor, module, retry}, opts) do
    log_info("Starting and monitoring #{retry}: #{inspect(opts)}...")

    case Swarm.whereis_or_register_name(
           module,
           DataProcessorSupervisor,
           :start_child,
           [module, opts]
         ) do
      {:ok, pid} ->
        Process.monitor(pid)

        {:noreply, {pid, opts}}

      other ->
        log_error("Error while fetching or registering process: #{inspect(other)}")

        Process.sleep(500)

        {:noreply, opts, {:continue, {:start_and_monitor, module, retry + 1}}}
    end
  end

  @impl true
  def handle_info({:DOWN, _, :process, pid, _reason}, {pid, [module: module] = opts}) do
    log_info("Process down, restarting... #{inspect(opts)}")

    {:noreply, opts, {:continue, {:start_and_monitor, module, 1}}}
  end

  defp log_error(message) do
    Logger.error("[#{__MODULE__}] [#{node()}] #{message}")
  end

  defp log_info(message) do
    Logger.info("[#{__MODULE__}] [#{node()}] #{message}")
  end
end
