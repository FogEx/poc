defmodule FogEx.CardiacArrestAnalysis.Create do
  alias FogEx.Models.CardiacArrestAnalysis
  alias FogEx.Repo

  def call(params) do
    params
    |> CardiacArrestAnalysis.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %CardiacArrestAnalysis{}} = result), do: result
  defp handle_insert({:error, reason}), do: {:error, reason}
end
