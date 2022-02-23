# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :fogex,
  namespace: FogEx,
  ecto_repos: [FogEx.Repo]

# Configures the endpoint
config :fogex, FogExWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nYgaKkv/Zr65YFx4KeKCEK+Qq9aB2beipjSeKKad/NeRGiSTiWDkdqodT032brOf",
  render_errors: [view: FogExWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: FogEx.PubSub,
  live_view: [signing_salt: "PMQzVmQh"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
