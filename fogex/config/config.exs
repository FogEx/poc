# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :fogex,
  namespace: FogEx,
  ecto_repos: [FogEx.Repo]

config :fogex, FogEx.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

# Configures the endpoint
config :fogex, FogExWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: FogExWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: FogEx.PubSub,
  live_view: [signing_salt: "WTwnWzds"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :fogex, event_stores: [FogEx.EventStore]

config :fogex, FogEx.EventStore, serializer: EventStore.JsonSerializer

config :fogex, :eventstore, FogEx.EventStore

config :fogex,
  mqtt_host: System.get_env("MQTT_HOST") || "localhost",
  mqtt_port: String.to_integer(System.get_env("MQTT_PORT") || "1883")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
