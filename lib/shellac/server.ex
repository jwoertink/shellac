defmodule Shellac.Server do
  alias Cauldron.Request, as: Request

  @doc """
    TODO: When the request comes in, take the path and find a Shellac.Cache by that key.
    The Shellac.Cache should be stored as the key "pages" in a Shellac.Registry.
    Need to figure out how to get the PID for the linked Registry in here to fetch.

    {:ok, cache} = Shellac.Registry.fetch(LINKED_REGISTRY, "pages")
    body = Shellac.Cache.get(cache, path)
    if body == nil do
      body = Shellac.Proxy.get!(path).body
    end
  """
  def handle("GET", %URI{path: path}, req) do
    body = Shellac.Proxy.get!(path).body
    req |> Request.reply(200, body)
  end
end
