defmodule FogEx.CardiacArrestAnalysis.GenerateNotificationEvent do
  alias FogEx.Events.NotificationEvent

  def call(
        %{
          hearth_rate: hearth_rate,
          respiratory_rate: respiratory_rate,
          hearth_rate_risk: _hearth_rate_risk,
          respiratory_rate_risk: _respiratory_rate_risk,
          risk: risk
        } = _cardiac_arrest_analysis,
        user_id,
        original_event
      ) do
    case risk do
      :error ->
        %NotificationEvent{
          type: :message,
          message: "Error processing cardiac arrest analysis of user #{user_id}",
          origin_event: original_event
        }

      cardiac_arrest_risk ->
        %NotificationEvent{
          type: :message,
          message:
            "The cardiac arrest risk (HR: #{hearth_rate} bpm, RR: #{respiratory_rate} ipm) of user #{user_id} is: #{Atom.to_string(cardiac_arrest_risk)}",
          origin_event: original_event
        }
    end
  end
end
