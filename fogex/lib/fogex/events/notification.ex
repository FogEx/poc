defmodule FogEx.Events.NotificationEvent do
  @derive [Poison.Encoder, Jason.Encoder]

  defstruct [:type, :message, :origin_event]
end
