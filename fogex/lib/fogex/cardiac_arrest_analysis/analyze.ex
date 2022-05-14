defmodule FogEx.CardiacArrestAnalysis.Analyze do
  # credo:disable-for-this-file Credo.Check.Refactor.CyclomaticComplexity

  @doc """
  Analyzes the hearth rate (bmp) and respiratory (ipm) rate passed and returns a risk of cardiac arrest.

  iex> FogEx.CardiacArrestAnalysis.Analyze.call(%{hearth_rate: 70, respiratory_rate: 16})
  {:low, :low, :low}

  iex> FogEx.CardiacArrestAnalysis.Analyze.call(%{hearth_rate: 45, respiratory_rate: 12})
  {:medium, :medium, :medium}

  iex> FogEx.CardiacArrestAnalysis.Analyze.call(%{hearth_rate: 181, respiratory_rate: 12})
  {:high, :high, :medium}

  iex> FogEx.CardiacArrestAnalysis.Analyze.call(%{hearth_rate: 70, respiratory_rate: 10})
  {:high, :low, :high}
  """
  def call(%{hearth_rate: hearth_rate, respiratory_rate: respiratory_rate}) do
    hr_risk = analyze_hearth_rate(hearth_rate)
    rr_risk = analyze_respiratory_rate(respiratory_rate)

    risk =
      case {hr_risk, rr_risk} do
        {:high, _} -> :high
        {_, :high} -> :high
        {:medium, :medium} -> :medium
        {_, :low} -> :low
        {:low, _} -> :low
        _ -> :unknown
      end

    {risk, hr_risk, rr_risk}
  end

  defp analyze_hearth_rate(hearth_rate) do
    cond do
      hearth_rate >= 60 and hearth_rate <= 100 -> :low
      hearth_rate >= 40 and hearth_rate < 60 -> :medium
      hearth_rate > 100 and hearth_rate <= 180 -> :medium
      hearth_rate < 40 -> :high
      hearth_rate > 180 -> :high
      true -> :unknown
    end
  end

  defp analyze_respiratory_rate(respiratory_rate) do
    cond do
      respiratory_rate >= 14 and respiratory_rate <= 18 -> :low
      respiratory_rate >= 12 and respiratory_rate < 14 -> :medium
      respiratory_rate < 12 -> :high
      true -> :unknown
    end
  end
end
