defmodule FogEx.Models.CardiacArrestAnalysis do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Enum

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [
    :hearth_rate,
    :respiratory_rate,
    :hearth_rate_risk,
    :respiratory_rate_risk,
    :risk
  ]

  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  @risk [:low, :medium, :high, :unknown]

  schema "cardiac_arrest_analysis" do
    field(:hearth_rate, :decimal)
    field(:respiratory_rate, :decimal)
    field(:hearth_rate_risk, Enum, values: @risk)
    field(:respiratory_rate_risk, Enum, values: @risk)
    field(:risk, Enum, values: @risk)

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
