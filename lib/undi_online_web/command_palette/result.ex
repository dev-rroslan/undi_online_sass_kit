defmodule UndiOnlineWeb.CommandPalette.Result do
  @moduledoc """
  Used to wrap command palette results and make it easier to iterate on.
  """
  defstruct [:record, :type, :first_type, :index]
end
