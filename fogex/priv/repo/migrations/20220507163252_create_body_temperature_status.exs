defmodule FogEx.Repo.Migrations.CreateBodyTemperatureStatus do
  use Ecto.Migration

  def change do
    up_query =
      "CREATE TYPE body_temperature_status AS ENUM ('hypothermia', 'normal', 'fever', 'hyperpyrexia', 'unknown')"

    down_query = "DROP TYPE body_temperature_status"

    execute(up_query, down_query)
  end
end
