defmodule FogEx.Notificator.Supervisor do
  use Supervisor

  alias FogEx.Notificator.NotificationRegisteredHandler

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_args) do
    notification_registered_handler_opts = %{
      stream_uuid: "notification_registered",
      subscription_name: "notification_registered_handler",
      concurrency_limit: 1
    }

    children = [
      Supervisor.child_spec({NotificationRegisteredHandler, notification_registered_handler_opts},
        id: :notification_registered_handler_1
      )
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
