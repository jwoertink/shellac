defmodule Shellac.Registry do
  use GenServer

  @doc """
    Start the registry server
  """
  def start_link(event_manager, opts \\ []) do
    GenServer.start_link(__MODULE__, event_manager, opts)
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

  # GenServer Callbacks

  def init(events) do
    names = HashDict.new
    refs = HashDict.new
    {:ok, %{names: names, refs: refs, events: events}}
  end

  def handle_call({:lookup, name}, _from, state) do
    {:reply, HashDict.fetch(state.names, name), state}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  def handle_cast({:create, name}, state) do
    if HashDict.get(state.names, name) do
      {:noreply, state}
    else
      {:ok, bucket} = Shellac.Cache.start_link
      ref = Process.monitor(bucket)
      refs = HashDict.put(state.refs, ref, name)
      names = HashDict.put(state.names, name, bucket)
      GenEvent.sync_notify(state.events, {:create, name, bucket})
      {:noreply, %{state | names: names, refs: refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, pid, _reason}, state) do
    {name, refs} = HashDict.pop(state.refs, ref)
    names = HashDict.delete(state.names, name)
    GenEvent.sync_notify(state.events, {:exit, name, pid})
    {:noreply, %{state | names: names, refs: refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
