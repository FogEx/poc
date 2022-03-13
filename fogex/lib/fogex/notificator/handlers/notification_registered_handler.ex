defmodule FogEx.Notificator.NotificationRegisteredHandler do
  use GenServer

  alias FogEx.EventStore
  # alias FogEx.Events.{NotificationEvent}

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

    {:ok, %{subscription: subscription}}
  end

  def init(%{}), do: {:stop, :bad_init_args}

  @impl true
  def handle_info({:subscribed, subscription}, %{subscription: subscription} = state) do
    {:noreply, state}
  end

  # Event notification
  def handle_info({:events, [event]}, state) do
    %{subscription: subscription} = state

    # TO-DO: handle notification event
    # %NotificationEvent{
    #   type: type,
    #   message: message,
    #   origin_event: origin_event
    # } = event.data

    # Confirm receipt of received events
    :ok = EventStore.ack(subscription, [event])

    {:noreply, state}
  end
end
