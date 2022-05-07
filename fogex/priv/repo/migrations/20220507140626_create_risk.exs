defmodule FogEx.Repo.Migrations.CreateRisk do
  use Ecto.Migration

  def change do
    up_query = "CREATE TYPE risk AS ENUM ('low', 'medium', 'high', 'unknown')"
    down_query = "DROP TYPE risk"

    execute(up_query, down_query)
  end
end
