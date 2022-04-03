defmodule FogExWeb.HealthController do
  use FogExWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{status: "Health"})
  end
end
