defmodule UndiOnlineWeb.Components.Badges do
  @moduledoc """
  Badges components
  """
  use Phoenix.Component

  @doc """
  Renders a badge.
  """
  attr :name, :string, default: "default"
  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <span class={[
      "text-xs font-medium px-2.5 py-0.5 rounded",
      @name == "info" && "bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-300",
      @name == "error" && "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300",
      @name == "success" && "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300",
      @name == "warning" && "bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300",
    ]}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end
end