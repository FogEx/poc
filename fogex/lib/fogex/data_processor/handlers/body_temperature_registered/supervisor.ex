defmodule FogEx.DataProcessor.BodyTemperatureRegistered.Supervisor do
  use Supervisor

  alias FogEx.DataProcessor.BodyTemperatureRegistered.Handler,
    as: BodyTemperatureRegisteredHandler

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_args) do
    num_handlers = 10

    handler_opts = %{
      stream_uuid: "body_temperature_registered",
      subscription_name: "body_temperature_registered_handler",
      concurrency_limit: num_handlers
    }

    children =
      1..num_handlers
      |> Enum.map(&create_handler_child_spec(&1, handler_opts))

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp create_handler_child_spec(handler_number, handler_opts) do
    Supervisor.child_spec(
      {BodyTemperatureRegisteredHandler, handler_opts},
      id: String.to_atom("body_temperature_registered_handler_#{handler_number}")
    )
  end
end
