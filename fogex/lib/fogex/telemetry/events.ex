defmodule FogEx.Telemetry.Events do
  def increment_total(opts \\ %{}) do
    :telemetry.execute([:events], %{total: 1}, opts)
  end

  def register_process_time(start_time, end_time, opts \\ %{}) do
    duration = end_time - start_time

    :telemetry.execute([:events], %{process_time: duration}, opts)
  end
end
