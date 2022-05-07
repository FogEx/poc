defmodule FogEx.BodyTemperatureAnalysis.GenerateNotificationEvent do
  alias FogEx.Events.NotificationEvent

  def call(
        %{status: status, temperature: temperature} = _body_temperature_analysis,
        user_id,
        original_event
      ) do
    case status do
      :error ->
        %NotificationEvent{
          type: :message,
          message: "Error processing body temperature of user #{user_id}",
          origin_event: original_event
        }

      status_body_temperature ->
        %NotificationEvent{
          type: :message,
          message:
            "The body temperature (#{temperature} Celsius) status of user #{user_id} is: #{Atom.to_string(status_body_temperature)}",
          origin_event: original_event
        }
    end
  end
end
