defmodule FogEx.Modules.Notificator.Starter do
  use GenServer

  alias FogEx.Modules.Notificator.Supervisor, as: NotificatorSupervisor

  alias FogEx.Modules.Notificator.NotificationRegistered.Supervisor,
    as: NotificationRegisteredSupervisor

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    {:ok, opts, {:continue, {:start_and_monitor, 1}}}
  end

  @impl true
  def handle_continue({:start_and_monitor, retry}, opts) do
    log_info("Starting and monitoring #{retry}: #{inspect(opts)}...")

    case Swarm.whereis_or_register_name(
           NotificationRegisteredSupervisor,
           NotificatorSupervisor,
           :start_child,
           [NotificationRegisteredSupervisor, opts]
         ) do
      {:ok, pid} ->
        Process.monitor(pid)

        {:noreply, {pid, opts}}

      other ->
        log_error("Error while fetching or registering process: #{inspect(other)}")

        Process.sleep(500)

        {:noreply, opts, {:continue, {:start_and_monitor, retry + 1}}}
    end
  end

  @impl true
  def handle_info({:DOWN, _, :process, pid, _reason}, {pid, opts}) do
    log_info("Process down, restarting... #{inspect(opts)}")

    {:noreply, opts, {:continue, {:start_and_monitor, 1}}}
  end

  defp log_error(message) do
    Logger.info("[#{__MODULE__}] [#{node()}] #{message}")
  end

  defp log_info(message) do
    Logger.info("[#{__MODULE__}] [#{node()}] #{message}")
  end
end
