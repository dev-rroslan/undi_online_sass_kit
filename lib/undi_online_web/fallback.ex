defmodule UndiOnlineWeb.Fallback do
  @moduledoc """
  Use this in a LiveView when a resource is not found.
  ```
  raise UndiOnlineWeb.Fallback
  ```
  """
  defexception message: "invalid route", plug_status: 404
end