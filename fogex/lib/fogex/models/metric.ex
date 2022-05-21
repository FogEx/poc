defmodule FogEx.Models.Metric do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @params [
    :node,
    :name,
    :measurement,
    :time,
    :label
  ]

  @required_params @params -- [:label]

  @derive {Jason.Encoder, only: @params ++ [:id]}

  schema "metric" do
    field(:node, :string)
    field(:name, :string)
    field(:measurement, :decimal)
    field(:time, :utc_datetime_usec)
    field(:label, :string)

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> handle_changes(params)
  end

  defp handle_changes(struct, params) do
    struct
    |> cast(params, @params)
    |> validate_required(@required_params)
  end
end
