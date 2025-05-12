defmodule LiveNest.Modal do
    @moduledoc """
    This module defines the Modal struct, which serves as a reference mechanism for modal views in the LiveNest framework.
    ``` LiveNest.Modal``` uses ``` LiveNest.Element``` to reference LiveViews, LiveComponents, and Components.
    
    See also:
    - [LiveNest.Element](LiveNest.Element.html)
    """

    @type id :: atom() | binary()
    @type modal_controller_pid :: pid()
    @type element :: LiveNest.Element.t()
    @type t :: %__MODULE__{modal_controller_pid: modal_controller_pid, element: element()}
    defstruct [:modal_controller_pid, :element]

    @doc """
    Prepares a LiveView for use in a modal.
    """
    @spec prepare_live_view(id(), module(), map()) :: t()
    def prepare_live_view(id, module, session \\ %{}) when is_atom(module) do
        modal_controller_pid = self() 
        session = prepare_options(session, modal_controller_pid, :live_view)
        %LiveNest.Modal{
            modal_controller_pid: modal_controller_pid, 
            element: LiveNest.Element.prepare_live_view(id, module, session)
        }
    end
  
    @spec prepare_live_component(id(), module(), map()) :: t()
    def prepare_live_component(id, module, params \\ %{}) when is_atom(module) do
        modal_controller_pid = self()
        params = prepare_options(params, modal_controller_pid, :live_component)
        %LiveNest.Modal{
            modal_controller_pid: modal_controller_pid, 
            element: LiveNest.Element.prepare_live_component(id, module, params)
        }
    end

    defp prepare_options(%{} = input_map, modal_controller_pid, :live_view) do
        Map.put(input_map, "modal_controller_pid", modal_controller_pid)
    end

    defp prepare_options(%{} = input_map, modal_controller_pid, :live_component) do
        Map.put(input_map, :modal_controller_pid, modal_controller_pid)
    end
    
    @doc """
    On mount callback for LiveViews that initializes the modal controller pid.
    """
    def on_mount(:initialize, _params, session, socket) do
        modal_controller_pid = Map.get(session, "modal_controller_pid")
        {:cont, socket |> Phoenix.Component.assign(modal_controller_pid: modal_controller_pid)}
    end

    @doc """
    LiveView macro that initializes the modal controller pid.
    """
    def live_view do
        quote do                
            on_mount {LiveNest.Modal, :initialize}
        end
    end

    @doc """
    LiveComponent macro that initializes the modal controller pid.
    """
    def live_component do
        quote do
            def update(%{modal_controller_pid: modal_controller_pid} = params, socket) do
                params = Map.drop(params, [:modal_controller_pid])
                update(params, socket |> Phoenix.Component.assign(modal_controller_pid: modal_controller_pid))
            end
        end
    end

    defmacro __using__(which) when is_atom(which) do
        apply(__MODULE__, which, [])
    end
end