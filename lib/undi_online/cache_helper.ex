defmodule UndiOnline.CacheHelper do
  @moduledoc """
  This cache helper can be used like this:

    import UndiOnline.CacheHelper

    posts = with_cache(
      "list_posts_cache_key",
      (fn ->
        Posts.list_posts()
      end)
    )
  """
  @cache_name :general_cache
  @default_ttl 1_000 * 60 * 60 # 1 hour

  def with_cache(key, fun, ttl \\ @default_ttl) do
    case Cachex.get(@cache_name, key) do
      {:ok, nil} ->
        result = fun.()
        Cachex.put(@cache_name, key, result, ttl: ttl)
        result
      {:ok, result} ->
        result
    end
  end
end
