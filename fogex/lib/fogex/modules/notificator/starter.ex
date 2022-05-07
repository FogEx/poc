defmodule FogEx.Modules.Notificator.Starter do
  alias FogEx.Modules.Notificator.Supervisor, as: NotificatorSupervisor

  alias FogEx.Modules.Notificator.NotificationRegistered.Supervisor,
    as: NotificationRegisteredSupervisor

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker
    }
  end

  def start_link(opts) do
    Swarm.register_name(
      NotificationRegisteredSupervisor,
      NotificatorSupervisor,
      :start_child,
      [NotificationRegisteredSupervisor, opts]
    )

    :ignore
  end
end
