defmodule FogEx.Telemetry.Mqtt do
  def increment_total(opts \\ %{}) do
    :telemetry.execute([:mqtt], %{total: 1}, opts)
  end

  def register_process_time(start_time, end_time, opts \\ %{}) do
    duration = end_time - start_time

    :telemetry.execute([:mqtt], %{process_time: duration}, opts)
  end
end
