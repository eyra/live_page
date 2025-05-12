defmodule LiveNest.Demo.HTML do
  @moduledoc """
  This module defines the demo HTML components.
  """

  use Phoenix.Component

  attr(:text, :string, required: true)

  def footer(assigns) do
    ~H"""
    <div>
      <p> {@text} </p>
    </div>
    """
  end
  
  attr(:title, :string, required: true)
  attr(:target, :string, required: true)
  slot(:inner_block, required: true)

  def modal(assigns) do
    ~H"""
      <div class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
        <h2> {@title} </h2>
        {render_slot(@inner_block)}
        <button phx-click="close_modal" phx-target={@target}>Close</button>
      </div>
    """
  end
end
