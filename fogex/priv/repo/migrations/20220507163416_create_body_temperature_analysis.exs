defmodule FogEx.Repo.Migrations.CreateBodyTemperatureAnalysis do
  use Ecto.Migration

  def change do
    create table(:body_temperature_analysis) do
      add(:temperature, :decimal)
      add(:status, :body_temperature_status)

      timestamps()
    end
  end
end
