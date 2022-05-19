defmodule FogEx.Utils.Node do
  def where_is(module) do
    Swarm.whereis_name(module)
    |> node()
    |> Atom.to_string()
    |> String.split("@")
    |> Enum.at(1)
  end
end
