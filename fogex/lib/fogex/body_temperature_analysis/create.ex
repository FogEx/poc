defmodule FogEx.BodyTemperatureAnalysis.Create do
  alias FogEx.Models.BodyTemperatureAnalysis
  alias FogEx.Repo

  def call(params) do
    params
    |> BodyTemperatureAnalysis.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %BodyTemperatureAnalysis{}} = result), do: result
  defp handle_insert({:error, reason}), do: {:error, reason}
end
