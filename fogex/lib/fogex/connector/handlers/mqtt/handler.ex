defmodule FogEx.Connector.MQTT.Handler do
  use Tortoise.Handler

  alias FogEx.Events.VitalSignEvent
  alias FogEx.EventStore

  require Logger

  def init(args) do
    {:ok, args}
  end

  def connection(status, state) do
    # `status` will be either `:up` or `:down`; you can use this to
    # inform the rest of your system if the connection is currently
    # open or closed; tortoise should be busy reconnecting if you get
    # a `:down`

    case status do
      :up ->
        Logger.debug("Got connected")

      :down ->
        Logger.debug("Got disconnected")
    end

    {:ok, state}
  end

  def handle_message(["vital_signs", user_id] = topic, payload, state) do
    Logger.debug("Message #{inspect(payload)} from topic #{Enum.join(topic, "/")}")

    {:ok, vital_sign} = Poison.decode(payload, as: %VitalSignEvent{}, keys: :atoms)

    event_name = "#{vital_sign.type}_registered"

    EventStore.append_to_stream(event_name, vital_sign)

    {:ok, state}
  end

  def handle_message(topic, payload, state) do
    # unhandled message! You will crash if you subscribe to something
    # and you don't have a 'catch all' matcher; crashing on unexpected
    # messages could be a strategy though.

    Logger.debug("Unhandled message #{inspect(payload)} from topic #{inspect(topic)}")

    {:ok, state}
  end

  def subscription(status, topic_filter, state) do
    {:ok, state}
  end

  def terminate(reason, state) do
    # tortoise doesn't care about what you return from terminate/2,
    # that is in alignment with other behaviours that implement a
    # terminate-callback

    :ok
  end
end
