defmodule FogEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :fogex,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {FogEx.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Web
      {:phoenix, "~> 1.6.6"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:phoenix_ecto, "~> 4.4"},
      {:plug_cowboy, "~> 2.5"},

      # Bibliotecas essenciais
      {:mqtt_potion, github: "brianmay/mqtt_potion", branch: "master"},
      {:eventstore, github: "commanded/eventstore", branch: "master"},
      {:libcluster, "~> 3.3"},
      {:swarm, "~> 3.4"},

      # Métricas
      {:telemetry_poller, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6"},

      # Base de dados
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},

      # Outras biblitecas úteis
      {:gettext, "~> 0.18"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:elixir_uuid, "~> 1.2"},

      # Serilização de JSON
      {:jason, "~> 1.2"},
      {:poison, "~> 5.0"},

      # AppSignal
      {:appsignal, "~> 2.0"},
      {:appsignal_phoenix, "~> 2.0"},
      {:telemetry_metrics_appsignal, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "event_store.setup", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "event_store.setup": ["event_store.create", "event_store.init"],
      "event_store.reset": ["event_store.drop", "event_store.create", "event_store.init"]
    ]
  end
end
