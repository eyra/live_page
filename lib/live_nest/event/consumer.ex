defmodule LiveNest.Event.Consumer do
    @moduledoc """
    A behaviour for handling events in LiveNest.
    """

    @callback consume_event(LiveNest.Event.t(), Phoenix.LiveView.Socket.t()) :: {:continue | :stop, Phoenix.LiveView.Socket.t()}

    defmacro __using__(_opts) do
        quote do
            @behaviour LiveNest.Event.Consumer
            alias LiveNest.Event

            def handle_info({@event, event} = message, socket) do
                socket = 
                    case consume_event(event, socket) do
                        {:continue, socket} -> Event.Publisher.publish_event(socket, event)
                        {:stop, socket} -> socket
                        _ -> raise "Unexpected response from consume_event/2. Please make sure to return {:continue, socket} or {:stop, socket}."
                    end

                {:noreply, socket}
            end

            @before_compile {LiveNest.Event.Consumer, :add_fallback_behaviour}
        end
    end

    defmacro add_fallback_behaviour(_env) do
        quote do
            def consume_event(event, socket) do
                Logger.debug("consume_event/2 not implemented for #{__MODULE__}, skipping event")
                {:continue, socket}
            end
        end
    end
end

