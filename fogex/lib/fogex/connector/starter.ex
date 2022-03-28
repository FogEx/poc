defmodule FogEx.Connector.Starter do
  alias FogEx.Connector
  alias FogEx.Connector.Supervisor, as: ConnectorSupervisor

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker
    }
  end

  def start_link(opts) do
    Swarm.register_name(Connector, ConnectorSupervisor, :start_child, [opts])

    :ignore
  end
end
