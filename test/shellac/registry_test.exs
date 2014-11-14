defmodule Shellac.RegistryTest do
  use ExUnit.Case, async: true

  defmodule Forwarder do
    use GenEvent

    def handle_event(event, parent) do
      send parent, event
      {:ok, parent}
    end
  end

  setup do
    {:ok, sup} = Shellac.Cache.Supervisor.start_link
    {:ok, manager} = GenEvent.start_link
    {:ok, registry} = Shellac.Registry.start_link(manager, sup)

    GenEvent.add_mon_handler(manager, Forwarder, self())
    {:ok, registry: registry}
  end

  test "#fetch returns :error if no bucket by name exists", %{registry: registry} do
    assert Shellac.Registry.fetch(registry, "pages") == :error
  end

  test "#store inserts a bucket called pages", %{registry: registry} do
    Shellac.Registry.store(registry, "pages")
    assert {:ok, bucket} = Shellac.Registry.fetch(registry, "pages")

    Shellac.Cache.put(bucket, "index.html", "<p>Hello</p>")
    assert Shellac.Cache.get(bucket, "index.html") == "<p>Hello</p>"
  end

  test "removes bucket on exit", %{registry: registry} do
    Shellac.Registry.store(registry, "pages")
    {:ok, bucket} = Shellac.Registry.fetch(registry, "pages")
    Agent.stop(bucket) #kill the bucket
    assert Shellac.Registry.fetch(registry, "pages") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    Shellac.Registry.store(registry, "pages")
    {:ok, bucket} = Shellac.Registry.fetch(registry, "pages")

    Process.exit(bucket, :shutdown) #kill bucket
    assert_receive {:exit, "pages", ^bucket}
    assert Shellac.Registry.fetch(registry, "pages") == :error
  end

  test "sends events on create and crash", %{registry: registry} do
    Shellac.Registry.store(registry, "pages")
    {:ok, bucket} = Shellac.Registry.fetch(registry, "pages")
    assert_receive {:create, "pages", ^bucket}

    Agent.stop(bucket)
    assert_receive {:exit, "pages", ^bucket}
  end
end
