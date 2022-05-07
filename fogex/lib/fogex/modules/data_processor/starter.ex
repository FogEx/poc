defmodule FogEx.Modules.DataProcessor.Starter do
  alias FogEx.Modules.DataProcessor.Supervisor, as: DataProcessorSupervisor

  alias FogEx.Modules.DataProcessor.BodyTemperatureRegistered.Supervisor,
    as: BodyTemperatureRegisteredSupervisor

  alias FogEx.Modules.DataProcessor.VitalSignsRegistered.Supervisor,
    as: VitalSignsRegisteredSupervisor

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker
    }
  end

  def start_link(opts) do
    Swarm.register_name(
      VitalSignsRegisteredSupervisor,
      DataProcessorSupervisor,
      :start_child,
      [VitalSignsRegisteredSupervisor, opts]
    )

    Swarm.register_name(
      BodyTemperatureRegisteredSupervisor,
      DataProcessorSupervisor,
      :start_child,
      [BodyTemperatureRegisteredSupervisor, opts]
    )

    :ignore
  end
end
