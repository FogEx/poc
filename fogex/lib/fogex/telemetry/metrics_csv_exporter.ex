defmodule FogEx.Telemetry.MetricsCsvExporter do
  alias FogEx.Telemetry.MetricsStorage
  alias FogExWeb.Telemetry

  def call(metric_name) do
    metrics = Telemetry.metrics()

    metric_name_as_atom =
      metric_name |> String.split(".") |> Enum.map(fn elem -> String.to_existing_atom(elem) end)

    metric = metrics |> Enum.find(fn elem -> elem.name == metric_name_as_atom end)

    metric_data = MetricsStorage.metrics_history(metric)

    csv_content =
      metric_data
      |> Stream.map(&map_metric_to_list(metric_name, &1))
      |> CSV.encode()
      |> Enum.to_list()
      |> to_string
  end

  defp map_metric_to_list(metric_name, %{
         node: node,
         label: label,
         measurement: measurement,
         time: time
       }) do
    [node, metric_name, label, measurement, dt_to_unix(time)]
  end

  defp dt_to_unix(time, unit \\ :microsecond) do
    time |> DateTime.to_unix(:microsecond)
  end
end
