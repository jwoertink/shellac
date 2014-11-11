defmodule Shellac.Server do
  alias Cauldron.Request, as: Request

  def handle("GET", %URI{path: path}, req) do
    body = Shellac.Proxy.get!(path).body
    req |> Request.reply(200, body)
  end
end
