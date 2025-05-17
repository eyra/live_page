defmodule LiveNest.Event.Consumer do
  @moduledoc """
  A behaviour for handling events in LiveNest.
  """

  @type continue_propagation :: {:continue, Phoenix.LiveView.Socket.t()}
  @type stop_propagation :: {:stop, Phoenix.LiveView.Socket.t()}
  @type consume_result :: continue_propagation | stop_propagation
  @callback consume_event(LiveNest.Event.t(), Phoenix.LiveView.Socket.t()) :: consume_result

  defmacro __using__(_opts) do
    quote do
      @behaviour LiveNest.Event.Consumer
      alias LiveNest.Event

      def handle_info({@event, event} = message, socket) do
        socket =
          case consume_event(event, socket) do
            {:continue, socket} -> Event.Publisher.publish_event(socket, event)
            {:stop, socket} -> socket
          end

        {:noreply, socket}
      end

      @before_compile {LiveNest.Event.Consumer, :add_fallback_behaviour}
    end
  end

  defmacro add_fallback_behaviour(_env) do
    quote do
      def consume_event(event, socket) do
        Logger.debug(
          "[Warning] #{__MODULE__}.consume_event/2 not implemented for event #{inspect(event)}"
        )

        {:continue, socket}
      end
    end
  end
end
