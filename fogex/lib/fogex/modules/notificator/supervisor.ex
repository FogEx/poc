defmodule FogEx.Modules.Notificator.Supervisor do
  use DynamicSupervisor

  require Logger

  def start_link(state) do
    DynamicSupervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(module, opts) do
    child_spec = %{
      id: module,
      start: {module, :start_link, [opts]},
      restart: :temporary
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  # Swarm callbacks
  def handle_call({:swarm, :begin_handoff}, _from, state) do
    Logger.debug("Begin handoff of module #{inspect(__MODULE__)} on #{node()}")

    {:reply, :restart, state}
  end

  def handle_cast({:swarm, :resolve_conflict, _}, state) do
    Logger.debug("Resolving conflict of module #{inspect(__MODULE__)} on #{node()}")

    {:noreply, state}
  end

  def handle_info({:swarm, :die}, state) do
    Logger.debug("Death of module #{inspect(__MODULE__)} on #{node()}")

    {:stop, :shutdown, state}
  end
end
