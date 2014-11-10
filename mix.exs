defmodule Shellac.Mixfile do
  use Mix.Project

  def project do
    [app: :shellac,
     version: "0.1.0",
     elixir: "~> 1.0",
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  # mix deps.get
  defp deps do
    [{:cauldron, github: "meh/cauldron"}]
  end
end
