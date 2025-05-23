defmodule LiveNest.Element do
  @moduledoc """
  This module defines the Element struct, which serves as a reference mechanism for Phoenix LiveViews, LiveComponents, and Components within the LiveNest framework.

  Examples:
  ```
  %Element{
    id: "my-live-view",
    type: :live_view,
    implementation: MyApp.MyLiveView,
    options: %{"title" => "My LiveView"}
  }

  %Element{
    id: "my-live-component",
    type: :live_component,
    implementation: MyApp.MyLiveComponent,
    options: %{"title" => "My LiveComponent"}
  }

  %Element{
    id: "my-component",
    type: :component,
    implementation: MyApp.MyComponent,
    options: %{"title" => "My Component"}
  }
  ```

  See also:
  - [LiveNest.HTML](LiveNest.HTML.html)
  - [LiveNest.Modal](LiveNest.Modal.html)
  - [LiveNest.Modal.Controller](LiveNest.Modal.Controller.html)
  - [LiveNest.Modal.Presenter](LiveNest.Modal.Presenter.html)
  """

  alias LiveNest.Element

  @type id :: atom() | binary()
  @type type :: :live_view | :live_component | :component
  @type options :: map()
  @type implementation :: atom()

  @type t :: %__MODULE__{id: id, type: type(), options: options(), implementation: implementation()}
  defstruct [:id, :type, :options, :implementation]

  @spec prepare_live_view(id(), module(), map()) :: t()
  def prepare_live_view(id, module, session \\ %{}) when is_atom(module) do
    %Element{id: id, type: :live_view, implementation: module, options: prepare_options(session, id, :live_view)}
  end

  @spec prepare_live_component(id(), module(), map()) :: t()
  def prepare_live_component(id, module, params \\ %{}) when is_atom(module) do
    %Element{id: id, type: :live_component, implementation: module, options: prepare_options(params, id, :live_component)}
  end

  @spec prepare_component(id(), function(), map()) :: t()
  def prepare_component(id, function, assigns \\ %{}) when is_function(function, 1) do
    %Element{id: id, type: :component, implementation: function, options: prepare_options(assigns, id, :component)}
  end

  defp prepare_options(%{} = input_map, id, :live_view) do
    Map.merge(input_map, %{"element_id" => id})
  end
  
  defp prepare_options(%{} = input_map, id, _) do
    Map.merge(input_map, %{element_id: id})
  end

  # On mount for live_views to assign the id
  def on_mount(:initialize, _params, session, socket) do
    element_id = Map.get(session, "element_id")
    {:cont, socket |> Phoenix.Component.assign(element_id: element_id)}
  end
end
