defmodule FogEx.Application do
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
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

      FogEx.EventStore,

      # Connector
      FogEx.Connector.Supervisor,
      FogEx.Connector.Starter,

      # DataProcessor
      FogEx.DataProcessor.Supervisor,
      FogEx.DataProcessor.Starter,

      # Notificator
      FogEx.Notificator.Supervisor,
      FogEx.Notificator.Starter
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

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
        # strategy: Cluster.Strategy.Gossip

        # Static nodes
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"node1@CASSIO-NOTE", :"node2@CASSIO-NOTE"]]
      ]
    ]
  end
end
