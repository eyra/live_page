defmodule LiveNest.Modal.Controller do
    @moduledoc """
    This module implements the ```Modal Controller``` concept.
    LiveViews that use this module will publish events to the ```Modal Presenter```.

    Example:
    ```
    defmodule MyApp.MyLiveView do
        use LiveNest.Modal.Controller

        def handle_event("present_my_modal", _, socket) do
            modal = LiveNest.Modal.prepare_live_view("my-modal", MyApp.MyModal)
            socket |> present_modal(modal)
        end
    end
    ```
    """

    defmacro __using__(_opts) do
        quote do
            import LiveNest.Event.Publisher, only: [publish_event: 2]

            require Logger
            require LiveNest.Constants
            @present_modal_event LiveNest.Constants.present_modal_event
            @hide_modal_event LiveNest.Constants.hide_modal_event

            def present_as_modal(socket, %LiveNest.Element{} = element) do
                modal = %LiveNest.Modal{
                    modal_controller_pid: self(),
                    element: element
                }

                present_modal(socket, modal)
            end

            def present_modal(socket, %LiveNest.Modal{} = modal) do
                publish_event(socket, %LiveNest.Event{
                    name: @present_modal_event,
                    payload: modal
                })
            end

            def hide_modal(socket, modal) do
                publish_event(socket, %LiveNest.Event{
                    name: @hide_modal_event,
                    payload: modal
                })
            end
        end
    end
end

