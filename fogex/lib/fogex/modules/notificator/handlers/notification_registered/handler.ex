defmodule FogEx.Modules.Notificator.NotificationRegistered.Handler do
  use FogEx.EventHandler

  alias FogEx.EventStore
  alias FogEx.Telemetry.Events, as: EventsTelemetry
  # alias FogEx.Events.{NotificationEvent}

  def handle_info({:events, [event]}, state) do
    start_time = System.monotonic_time()

    %{subscription: subscription, stream_uuid: stream_uuid} = state

    EventsTelemetry.increment_total(%{
      type: String.to_atom(stream_uuid)
    })

    # TO-DO: handle notification event
    # %NotificationEvent{
    #   type: type,
    #   message: message,
    #   origin_event: origin_event
    # } = event.data

    # Confirm receipt of received events
    :ok = EventStore.ack(subscription, [event])

    EventsTelemetry.register_process_time(start_time, System.monotonic_time(), %{
      type: String.to_atom(stream_uuid)
    })

    {:noreply, state}
  end
end
