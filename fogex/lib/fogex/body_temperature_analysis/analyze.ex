defmodule FogEx.BodyTemperatureAnalysis.Analyze do
  def call(temperature) do
    cond do
      temperature <= 35 -> :hypothermia
      temperature >= 36 and temperature <= 37.5 -> :normal
      temperature >= 37.6 and temperature < 40 -> :fever
      temperature >= 40 and temperature <= 41.5 -> :hyperpyrexia
      true -> :unknown
    end
  end
end
