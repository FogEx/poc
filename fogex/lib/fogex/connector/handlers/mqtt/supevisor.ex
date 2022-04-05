defmodule FogEx.Connector.MQTT.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    mqtt_host = Application.get_env(:fogex, :mqtt_host)
    mqtt_port = Application.get_env(:fogex, :mqtt_port)

    mqtt_opts = [
      client_id: "connector_mqtt_client",
      server: {
        Tortoise.Transport.Tcp,
        host: mqtt_host, port: mqtt_port
      },
      handler: {FogEx.Connector.MQTT.Handler, []},
      subscriptions: [
        {"vital_signs/#", 0}
      ]
    ]

    children = [
      {Tortoise.Connection, mqtt_opts}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
