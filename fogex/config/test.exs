import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :fogex, FogEx.Repo,
  username: "postgres",
  password: "postgres",
  database: "fogex_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :fogex, FogEx.TestEventStore,
  serializer: EventStore.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "eventstore_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost"

config :fogex, event_stores: [FogEx.TestEventStore]

config :fogex, :eventstore, FogEx.TestEventStore

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fogex, FogExWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "CuPulJ1c9iV5co89G14B5qpk1DB9i1Go32WAK4Lqs09haS1/BR040OvfV/CQkLkT",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
