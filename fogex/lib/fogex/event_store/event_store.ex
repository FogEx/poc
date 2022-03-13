defmodule FogEx.EventStore do
  use EventStore, otp_app: :fogex

  alias EventStore.Streams.StreamInfo

  def append_to_stream(event_name, event) do
    events = [
      %EventData{
        data: event
      }
    ]

    with {:ok, %StreamInfo{stream_version: stream_version}} <- stream_info(event_name),
         :ok <- append_to_stream(event_name, stream_version, events) do
      {:ok, events}
    else
      {:error, :stream_not_found} -> append_to_stream(event_name, 0, events)
    end
  end

  def subscribe(stream_uuid, subscription_name, subscriber_pid, concurrency_limit) do
    by_stream = fn %{stream_uuid: stream_uuid} -> stream_uuid end

    {:ok, subscription} =
      subscribe_to_stream(stream_uuid, subscription_name, subscriber_pid,
        concurrency_limit: concurrency_limit,
        partition_by: by_stream
      )

    subscription
  end
end
