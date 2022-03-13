defmodule FogEx.DataProcessor.Supervisor do
  use Supervisor

  alias FogEx.DataProcessor.BodyTemperatureRegisteredHandler

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_args) do
    body_temperature_opts = %{
      stream_uuid: "body_temperature_registered",
      subscription_name: "body_temperature_registered_handler",
      concurrency_limit: 1
    }

    children = [
      Supervisor.child_spec({BodyTemperatureRegisteredHandler, body_temperature_opts},
        id: :body_temperature_registered_handler_1
      )
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
