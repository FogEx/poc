defmodule FogEx.DataProcessor.BodyTemperatureRegistered.Handler do
  use GenServer

  alias FogEx.EventStore
  alias FogEx.Events.{NotificationEvent, VitalSignEvent}
  alias FogEx.Health.BodyTemperature
  alias FogEx.Telemetry.Events, as: EventsTelemetry

  def start_link(initial_args) do
    GenServer.start_link(__MODULE__, initial_args)
  end

  # Callbacks
  @impl true
  def init(%{
        stream_uuid: stream_uuid,
        subscription_name: subscription_name,
        concurrency_limit: concurrency_limit
      }) do
    subscription = EventStore.subscribe(stream_uuid, subscription_name, self(), concurrency_limit)

    state = %{
      subscription: subscription,
      subscription_name: subscription_name,
      stream_uuid: stream_uuid
    }

    {:ok, state}
  end

  def init(%{}), do: {:stop, :bad_init_args}

  @impl true
  def handle_info({:subscribed, subscription}, %{subscription: subscription} = state) do
    {:noreply, state}
  end

  # Event notification
  def handle_info({:events, [event]}, state) do
    start_time = System.monotonic_time()

    %{subscription: subscription, stream_uuid: stream_uuid} = state

    EventsTelemetry.increment_total(%{
      type: String.to_atom(stream_uuid)
    })

    %VitalSignEvent{user_id: user_id, data: %{temperature: body_temperature}} = event.data

    notification =
      case BodyTemperature.verify(body_temperature) do
        :error ->
          %NotificationEvent{
            type: :message,
            message: "Error processing body temperature of user #{user_id}",
            origin_event: event.data
          }

        status_body_temperature ->
          %NotificationEvent{
            type: :message,
            message:
              "The body temperature (#{body_temperature} Celsius) status of user #{user_id} is: #{Atom.to_string(status_body_temperature)}",
            origin_event: event.data
          }
      end

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
