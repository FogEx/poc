defmodule FogEx.EventHandler do
  defmacro __using__(_) do
    quote do
      use GenServer

      require Logger

      alias FogEx.EventStore

      def start_link(initial_args) do
        GenServer.start_link(__MODULE__, initial_args)
      end

      @impl true
      def init(%{
            stream_uuid: stream_uuid,
            subscription_name: subscription_name,
            concurrency_limit: concurrency_limit
          }) do
        subscription =
          EventStore.subscribe(stream_uuid, subscription_name, self(), concurrency_limit)

        state = %{
          subscription: subscription,
          subscription_name: subscription_name,
          stream_uuid: stream_uuid
        }

        {:ok, state}
      end

      @impl true
      def init(%{}) do
        log_error("Bad arguments to start event handler")

        {:stop, :bad_arguments}
      end

      @impl true
      def handle_info(
            {:subscribed, _subscription},
            %{subscription_name: subscription_name} = state
          ) do
        log_info("Subscribed to #{subscription_name}")

        {:noreply, state}
      end

      defp log_error(message) do
        Logger.error("[#{__MODULE__}] [#{node()}] #{message}")
      end

      defp log_info(message) do
        Logger.info("[#{__MODULE__}] [#{node()}] #{message}")
      end
    end
  end
end
