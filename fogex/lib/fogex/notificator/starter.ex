defmodule FogEx.Notificator.Starter do
  alias FogEx.Notificator
  alias FogEx.Notificator.Supervisor, as: NotificatorSupervisor

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker
    }
  end

  def start_link(opts) do
    Swarm.register_name(Notificator, NotificatorSupervisor, :start_child, [opts])

    :ignore
  end
end
