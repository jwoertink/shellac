defmodule Shellac.Mixfile do
  use Mix.Project

  def project do
    [app: :shellac,
     version: "0.1.0",
     elixir: "~> 1.0",
     deps: deps]
  end

  def application do
    [applications: [],
    mod: {Shellac, []}]
  end

  # mix deps.get
  defp deps do
    [
      {:cauldron, github: "meh/cauldron"},
      {:httpoison, "~> 0.5"}
    ]
  end
end
