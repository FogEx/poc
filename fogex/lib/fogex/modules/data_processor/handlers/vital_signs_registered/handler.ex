defmodule FogEx.Modules.DataProcessor.VitalSignsRegistered.Handler do
  use FogEx.EventHandler

  alias FogEx.Events.VitalSignEvent
  alias FogEx.EventStore
  alias FogEx.CardiacArrestAnalysis.{Analyze, Create, GenerateNotificationEvent}
  alias FogEx.Telemetry.Events, as: EventsTelemetry

  require Logger

  # Event notification
  def handle_info({:events, [event]}, state) do
    start_time = System.monotonic_time()

    %{subscription: subscription, stream_uuid: stream_uuid} = state

    EventsTelemetry.increment_total(%{
      type: String.to_atom(stream_uuid)
    })

    %VitalSignEvent{
      user_id: user_id,
      data: %{hearth_rate: hearth_rate, respiratory_rate: respiratory_rate}
    } = event.data

    {risk, hearth_rate_risk, respiratory_rate_risk} =
      Analyze.call(%{hearth_rate: hearth_rate, respiratory_rate: respiratory_rate})

    {:ok, cardiac_arrest_analysis} =
      Create.call(%{
        hearth_rate: hearth_rate,
        respiratory_rate: respiratory_rate,
        hearth_rate_risk: hearth_rate_risk,
        respiratory_rate_risk: respiratory_rate_risk,
        risk: risk
      })

    notification = GenerateNotificationEvent.call(cardiac_arrest_analysis, user_id, event.data)

    if notification do
      EventStore.append_to_stream("notification_registered", notification)
    end

    # Confirm receipt of received events
    :ok = EventStore.ack(subscription, [event])

    EventsTelemetry.register_process_time(start_time, System.monotonic_time(), %{
      type: String.to_atom(stream_uuid)
    })

    {:noreply, state}
  end
end
