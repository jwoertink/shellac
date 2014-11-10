defmodule Shellac.Registry do
  use GenServer

  @doc """
    Start the registry server
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
    Looks for a bucket called `name` registered with `server`
    Returns `{:ok, pid}` or `:error` if missing
  """
  def fetch(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
    Stores a bucket called `name` to `server`
  """
  def store(server, name) do
    GenServer.cast(server, {:create, name})
  end

  @doc """
    Stops the GenServer Registry
  """
  def stop_link(server) do
    GenServer.call(server, :stop)
  end

  # Server Callbacks

  def init(:ok) do
    names = HashDict.new
    refs = HashDict.new
    {:ok, {names, refs}}
  end

  def handle_call({:lookup, name}, _from, {names, _} = state) do
    {:reply, HashDict.fetch(names, name), state}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  def handle_cast({:create, name}, {names, refs}) do
    if HashDict.get(names, name) do
      {:noreply, names}
    else
      {:ok, bucket} = Shellac.Cache.start_link()
      ref = Process.monitor(bucket)
      refs = HashDict.put(refs, ref, name)
      names = HashDict.put(names, name, bucket)
      {:noreply, {names, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = HashDict.pop(refs, ref)
    names = HashDict.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
