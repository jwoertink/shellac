defmodule Shellac do
  use Application

  @doc """
    Entry point into application
  """
  def start(_type, _args) do
    Shellac.Supervisor.start_link
  end
end
