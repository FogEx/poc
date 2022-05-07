defmodule FogEx.Repo.Migrations.CreateCardiacArrestAnalysis do
  use Ecto.Migration

  def change do
    create table(:cardiac_arrest_analysis) do
      add(:hearth_rate, :decimal)
      add(:respiratory_rate, :decimal)
      add(:hearth_rate_risk, :risk)
      add(:respiratory_rate_risk, :risk)
      add(:risk, :risk)

      timestamps()
    end
  end
end
