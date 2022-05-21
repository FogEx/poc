defmodule FogEx.Repo.Migrations.CreateMetric do
  use Ecto.Migration

  def change do
    create table(:metric) do
      add(:node, :string)
      add(:name, :string)
      add(:measurement, :decimal)
      add(:time, :utc_datetime_usec)
      add(:label, :string)

      timestamps()
    end
  end
end
