defmodule FogExWeb.Router do
  use FogExWeb, :router

  import Plug.BasicAuth

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(:basic_auth, Application.get_env(:fogex, :basic_auth))
  end

  scope "/api", FogExWeb do
    pipe_through(:api)

    get("/health", HealthController, :index)
  end

  scope "/api", FogExWeb do
    pipe_through(:api)

    get("/metrics", MetricsController, :index)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  import Phoenix.LiveDashboard.Router

  scope "/" do
    if Mix.env() == :prod do
      pipe_through(:auth)
    end

    pipe_through([:fetch_session, :protect_from_forgery])

    live_dashboard("/dashboard",
      metrics: FogExWeb.Telemetry,
      metrics_history: {FogEx.Telemetry.MetricsStorage, :metrics_history, []}
    )
  end
end
