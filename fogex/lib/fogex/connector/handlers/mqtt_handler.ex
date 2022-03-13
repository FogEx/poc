defmodule FogEx.MQTTHandler do
  use GenServer

  alias EventStore.EventData
  alias FogEx.Events.VitalSignEvent
  alias FogEx.EventStore

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  # Callbacks

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl true
  def handle_cast({:mqtt, :connect}, state) do
    IO.puts("Got connect")
    {:noreply, state}
  end

  @impl true
  def handle_cast({:mqtt, :disconnect}, state) do
    IO.puts("Got disconnect")
    {:noreply, state}
  end

  @impl true
  def handle_cast({:mqtt, :publish, "vital_signs/" <> user_id = topic, message}, state) do
    IO.puts("Got message #{inspect(message)} from topic #{inspect(topic)}")

    {:ok, vital_sign} = Poison.decode(message, as: %VitalSignEvent{}, keys: :atoms)

    # events = [
    #   %EventData{
    #     event_type: "Elixir.FogEx.VitalSignEvent",
    #     data: vital_sign
    #   }
    # ]

    event_name = vital_sign.type <> "_registered"

    EventStore.append_to_stream(event_name, vital_sign)

    {:noreply, state}
  end

  @impl true
  def handle_cast({:mqtt, :publish, topic, message}, state) do
    IO.puts("Unhandled message #{inspect(message)} from topic #{inspect(topic)}")
    {:noreply, state}
  end
end
