defmodule Sellac.CacheTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = Shellac.Cache.start_link
    Shellac.Cache.put(bucket, "index.html", "<p>Hello</p>")
    {:ok, bucket: bucket}
  end

  test "stores value by key", %{bucket: bucket} do
    assert Shellac.Cache.get(bucket, "index.html") == "<p>Hello</p>"
  end

  test "deltes value by key", %{bucket: bucket} do
    Shellac.Cache.delete(bucket, "index.html")
    assert Shellac.Cache.get(bucket, "index.html") == nil
  end
end
