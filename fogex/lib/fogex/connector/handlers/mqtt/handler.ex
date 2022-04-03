defmodule FogEx.Connector.MQTT.Handler do
  use GenServer

  alias FogEx.Events.VitalSignEvent
  alias FogEx.EventStore

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # Callbacks
  @impl true
  def init(opts) do
    {:ok, opts}
  end

  @impl true
  def handle_cast({:mqtt, :connect}, state) do
    Logger.debug("Got connect")

    {:noreply, state}
  end

  @impl true
  def handle_cast({:mqtt, :disconnect}, state) do
    Logger.debug("Got disconnect")

    {:noreply, state}
  end

  @impl true
  def handle_cast({:mqtt, :publish, "vital_signs/" <> user_id = topic, message}, state) do
    Logger.debug("Got message #{inspect(message)} from topic #{inspect(topic)}")

    {:ok, vital_sign} = Poison.decode(message, as: %VitalSignEvent{}, keys: :atoms)

    event_name = vital_sign.type <> "_registered"

    EventStore.append_to_stream(event_name, vital_sign)

    {:noreply, state}
  end

  @impl true
  def handle_cast({:mqtt, :publish, topic, message}, state) do
    Logger.debug("Unhandled message #{inspect(message)} from topic #{inspect(topic)}")

    {:noreply, state}
  end
end
