defmodule Shellac.Server do
  alias Cauldron.Request, as: Request

  def handle("GET", %URI{path: "/"}, req) do
    req |> Request.reply(200, "<h1>Hello World!</h1>")
  end
end
