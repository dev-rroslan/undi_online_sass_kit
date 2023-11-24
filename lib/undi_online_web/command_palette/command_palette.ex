defmodule UndiOnlineWeb.CommandPalette do
  @moduledoc """
  Some text
  """
  @possible_contexts ["app", "admin"]

  use UndiOnlineWeb, :verified_routes

  alias UndiOnlineWeb.CommandPalette.Result

  def search(search_phrase, opts \\ [])

  def search("", _), do: []
  def search(search_phrase, opts) do
    context = Keyword.get(opts, :context, "app")

    if context not in @possible_contexts do
      raise "The context needs to be in a possible contexts. "
    end

    [
      search_routes(context, search_phrase),
      search_records(context, search_phrase)
    ]
    |> flatten_and_add_index()
  end

  defp flatten_and_add_index(results) do
    results
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.map(fn {result, idx} -> Map.put(result, :index, idx) end)
  end

  defp search_routes(context, search_phrase) do
    routes(context)
    |> Enum.filter(fn %{label: label, path: path} ->
      matches?(label, search_phrase) || matches?(path, search_phrase)
    end)
    |> Enum.with_index()
    |> Enum.map(fn {route, idx} ->
      %Result{
        record: route,
        type: :route,
        first_type: idx == 0
      }
    end)
  end

  defp search_records(context, search_phrase) do
    params = %{filters: [%{field: :search_phrase, op: :ilike_or, value: search_phrase}], limit: 4}

    schemas(context)
    |> Enum.reduce([], fn schema, memo ->

      case Flop.validate_and_run(schema, params, for: schema) do
        {:ok, {[_|_] = records, _meta}} -> Enum.concat(records, memo)
        _ -> memo
      end
      |> Enum.with_index()
      |> Enum.map(fn {record, idx} ->
        %Result{
          record: record,
          type: schema,
          first_type: idx == 0
        }
      end)

    end)
  end

  defp matches?(first, second) do
    String.starts_with?(
      String.downcase(first), String.downcase(second)
    )
  end

  def routes("app") do
    [
      %{label: "Dashboard", path: ~p"/"},
      %{label: "Settings", path: ~p"/users/settings"},
      ## ADD ADDITIONAL ROUTES BELOW ##
    ]
  end

  def routes("admin") do
    [
      %{label: "Dashboard", path: ~p"/admin"},
      ## ADD ADDITIONAL ADMIN ROUTES BELOW ##
    ]
  end

  def schemas("app") do
    [
      ## ADD ADDITIONAL SCHEMAS BELOW ##
    ]
  end

  def schemas("admin") do
    [
      UndiOnline.Users.User,
      ## ADD ADDITIONAL ADMIN SCHEMAS BELOW ##
    ]
  end
end
