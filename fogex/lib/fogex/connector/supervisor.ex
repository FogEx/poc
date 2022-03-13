defmodule FogEx.Connector.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_args) do
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
      handler_pid: FogEx.MQTTHandler,
      subscriptions: [
        {"vital_signs/#", 0}
      ]
    ]

    children = [
      {MqttPotion.Connection, mqtt_opts},
      FogEx.MQTTHandler
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
