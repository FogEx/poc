defmodule FogEx.Events.VitalSignEvent do
  @derive [Poison.Encoder, Jason.Encoder]

  defstruct [:type, :data, :user_id]
end
