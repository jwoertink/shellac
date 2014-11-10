defmodule Shellac.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = Shellac.Registry.start_link
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
end
