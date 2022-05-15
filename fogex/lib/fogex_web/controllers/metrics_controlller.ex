defmodule FogExWeb.MetricsController do
  use FogExWeb, :controller

  alias FogEx.Telemetry.MetricsCsvExporter

  def index(conn, %{"metric" => metric_name}) do
    csv_content = MetricsCsvExporter.call(metric_name)

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"#{metric_name}.csv\"")
    |> send_resp(200, csv_content)
  end

  def index(conn, _) do
    conn
    |> put_status(:bad_request)
    |> json(%{message: "Invalid metric request"})
  end
end
