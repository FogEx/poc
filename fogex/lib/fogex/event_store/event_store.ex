defmodule FogEx.EventStore do
  use EventStore, otp_app: :fogex

  alias EventStore.Streams.StreamInfo

  def get_event_store do
    Application.get_env(:fogex, :eventstore)
  end

  def append_to_stream(event_name, event) do
    event_store = get_event_store()

    events = [
      %EventData{
        data: event
      }
    ]

    with {:ok, %StreamInfo{stream_version: stream_version}} <- stream_info(event_name),
         :ok <- event_store.append_to_stream(event_name, stream_version, events) do
      {:ok, events}
    else
      {:error, :stream_not_found} -> event_store.append_to_stream(event_name, 0, events)
    end
  end

  def subscribe(stream_uuid, subscription_name, subscriber_pid, concurrency_limit) do
    event_store = get_event_store()
    by_stream = fn %{stream_uuid: stream_uuid} -> stream_uuid end

    {:ok, subscription} =
      event_store.subscribe_to_stream(stream_uuid, subscription_name, subscriber_pid,
        concurrency_limit: concurrency_limit,
        partition_by: by_stream
      )

    subscription
  end
end
