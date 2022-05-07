defmodule FogEx.Modules.Connector.MQTT.Supervisor do
  use Supervisor

  @impl true
  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_opts) do
    mqtt_host = Application.get_env(:fogex, :mqtt_host)
    mqtt_port = Application.get_env(:fogex, :mqtt_port)

    mqtt_opts = [
      name: MqttPotion.Connection,
      host: mqtt_host,
      port: mqtt_port,
      ssl: false,
      protocol_version: 5,
      client_id: "connector_mqtt_client",
      ssl_opts: [],
      handler_pid: FogEx.Modules.Connector.MQTT.Handler,
      subscriptions: [
        {"vital_signs/#", 0}
      ]
    ]

    children = [
      {MqttPotion.Connection, mqtt_opts},
      FogEx.Modules.Connector.MQTT.Handler
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
