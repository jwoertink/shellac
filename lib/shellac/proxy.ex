defmodule Shellac.Proxy do
  use HTTPoison.Base

  def process_url(url \\ "/") do
    config = Mix.Config.read!("config/config.exs")[:shellac][:backend]
    config.host <> ":#{config.port}" <> url
  end

  def process_response_body(body) do
    body
  end
end
