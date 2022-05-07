defmodule FogEx.Modules.Connector.Starter do
  alias FogEx.Modules.Connector.Supervisor, as: ConnectorSupervisor

  alias FogEx.Modules.Connector.MQTT.Supervisor, as: MQTTSupervisor

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker
    }
  end

  def start_link(opts) do
    Swarm.register_name(MQTTSupervisor, ConnectorSupervisor, :start_child, [MQTTSupervisor, opts])

    :ignore
  end
end
