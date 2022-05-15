defmodule FogExWeb.HealthController do
  use FogExWeb, :controller

  alias Ecto.Adapters.SQL
  alias FogEx.Repo

  def index(conn, _params) do
    {db_status, _} = Repo |> SQL.query("SELECT version()", [])

    status =
      case db_status do
        :ok -> %{status: "Health", node: node()}
        _ -> %{status: "Unhealth", node: node()}
      end

    conn
    |> put_status(:ok)
    |> json(status)
  end
end
