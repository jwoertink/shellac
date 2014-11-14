defmodule Shellac.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @manager_name Shellac.EventManager
  @registry_name Shellac.Registry
  @cache_supervisor_name Shellac.Cache.Supervisor

  def init(:ok) do
    children = [
      worker(GenEvent, [[name: @manager_name]]),
      supervisor(Shellac.Cache.Supervisor, [[name: @cache_supervisor_name]]),
      worker(Shellac.Registry, [@manager_name, @cache_supervisor_name, [name: @registry_name]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
