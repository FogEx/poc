defmodule FogEx.Health.BodyTemperature do
  def verify(t) do
    cond do
      t <= 35 -> :hypothermia
      t >= 36 and t <= 37.5 -> :normal
      t >= 37.6 and t < 40 -> :fever
      t >= 40 and t <= 41.5 -> :hyperpyrexia
      true -> :error
    end
  end
end
