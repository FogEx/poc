defmodule FogEx.DataProcessor.Starter do
  alias FogEx.DataProcessor
  alias FogEx.DataProcessor.Supervisor, as: DataProcessorSupervisor

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker
    }
  end

  def start_link(opts) do
    Swarm.register_name(DataProcessor, DataProcessorSupervisor, :start_child, [opts])

    :ignore
  end
end
