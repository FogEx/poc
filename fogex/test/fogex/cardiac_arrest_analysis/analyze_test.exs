defmodule FogEx.CardiacArrestAnalysis.AnalyzeTest do
  use ExUnit.Case

  alias FogEx.CardiacArrestAnalysis.Analyze

  doctest Analyze

  describe "call/1" do
    test "should returns risk correctly" do
      risk = Analyze.call(%{hearth_rate: 120, respiratory_rate: 8})

      assert {:high, :medium, :high} == risk
    end
  end
end
