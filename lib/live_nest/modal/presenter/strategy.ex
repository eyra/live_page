defmodule LiveNest.Modal.Presenter.Strategy do
    @moduledoc """
    A behaviour for handling modal presentation in LiveNest.
    """

    @type socket :: Phoenix.LiveView.Socket.t()
    @type modal :: LiveNest.Modal.t()
    @type modal_id :: String.t()

    # Events from the controller
    @callback handle_present_modal(socket(), modal()) :: socket()
    @callback handle_hide_modal(socket(), modal()) :: socket()
    
    # Events from within the modal
    @callback handle_close_modal(socket(), modal_id()) :: socket()
end
