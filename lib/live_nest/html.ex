defmodule LiveNest.HTML do
  @moduledoc """
  This module implements helper HTML components:

  * element/1
  * live_view/1
  * component/1

  See also:
  - [LiveNest.Element](LiveNest.Element.html)
  """

  use Phoenix.Component


  @doc """
  Renders an element (LiveView, LiveComponent, or Component).
  """
  attr(:socket, :any, required: true)
  attr(:id, :any, required: true)
  attr(:type, :any, required: true)
  attr(:implementation, :any)
  attr(:options, :any)

  def element(%{type: :live_view} = assigns) do
    ~H"""
      <.live_view socket={@socket} id={@id} module={@implementation} session={@options} />
    """
  end

  def element(%{type: :live_component} = assigns) do
    ~H"""
      <.live_component id={@id} module={@implementation} {@options} />
    """
  end

  def element(%{type: :component} = assigns) do  
    ~H"""
      <.component id={@id} function={@implementation} assigns={@options} />
    """
  end


  @doc """
  Renders a LiveView.
  """
  attr(:socket, :any, required: true)
  attr(:module, :any, required: true)
  attr(:id, :any, required: true)
  attr(:session, :any)

  def live_view(%{session: nil} = assigns) do
    live_view(assigns |> Map.put(:session, %{}))
  end

  def live_view(assigns) do
    ~H"""
    <div>
      {live_render(@socket, @module, id: @id, session: @session)}
    </div>
    """
  end

  @doc """
  Renders a Component.
  """ 
  attr(:id, :any, required: true)
  attr(:function, :any, required: true)
  attr(:assigns, :any)

  def component(assigns) do
    ~H"""
      <div id={@id}>
        {@function.(@assigns)}
      </div>
    """
  end
  
end
