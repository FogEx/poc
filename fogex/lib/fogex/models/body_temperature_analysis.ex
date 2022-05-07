defmodule FogEx.Models.BodyTemperatureAnalysis do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Enum

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [
    :temperature,
    :status
  ]

  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  @body_temperature_status [:hypothermia, :normal, :fever, :hyperpyrexia, :unknown]

  schema "body_temperature_analysis" do
    field(:temperature, :decimal)
    field(:status, Enum, values: @body_temperature_status)

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> handle_changes(params, @required_params)
  end

  defp handle_changes(struct, params, fields) do
    struct
    |> cast(params, fields)
    |> validate_required(fields)
  end
end
