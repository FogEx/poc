defmodule FogEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias FogEx.Modules.DataProcessor.BodyTemperatureRegistered.Supervisor,
    as: BodyTemperatureRegisteredSupervisor

  alias FogEx.Modules.DataProcessor.VitalSignsRegistered.Supervisor,
    as: VitalSignsRegisteredSupervisor

  @impl true
  def start(_type, _args) do
    event_store = Application.get_env(:fogex, :eventstore)

    children = [
      {Cluster.Supervisor, [topologies(), [name: FogEx.Cluster.Supervisor]]},

      # Start the Ecto repository
      FogEx.Repo,

      # Start the Telemetry supervisor
      FogExWeb.Telemetry,

      # Start the PubSub system
      {Phoenix.PubSub, name: FogEx.PubSub},

      # Start the Endpoint (http/https)
      FogExWeb.Endpoint,

      # Start a worker by calling: FogEx.Worker.start_link(arg)
      # {FogEx.Worker, arg}

      event_store,

      # Connector Module
      FogEx.Modules.Connector.Supervisor,
      FogEx.Modules.Connector.Starter,

      # DataProcessor Module
      FogEx.Modules.DataProcessor.Supervisor,
      Supervisor.child_spec(
        {FogEx.Modules.DataProcessor.Starter,
         [
           module: BodyTemperatureRegisteredSupervisor,
           name: BodyTemperatureRegisteredSupervisor.Starter
         ]},
        id: BodyTemperatureRegisteredSupervisor.Starter
      ),
      Supervisor.child_spec(
        {FogEx.Modules.DataProcessor.Starter,
         [
           module: VitalSignsRegisteredSupervisor,
           name: VitalSignsRegisteredSupervisor.Starter
         ]},
        id: VitalSignsRegisteredSupervisor.Starter
      ),

      # Notificator Module
      FogEx.Modules.Notificator.Supervisor,
      FogEx.Modules.Notificator.Starter
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FogEx.Supervisor]

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FogExWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp topologies do
    [
      fogex: [
        # Node discovery by UTP multicast
        strategy: Cluster.Strategy.Gossip

        # Static nodes
        # strategy: Cluster.Strategy.Epmd,
        # config: [hosts: [:"node1@CASSIO-NOTE", :"node2@CASSIO-NOTE"]]
      ]
    ]
  end
end
