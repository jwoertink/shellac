defmodule Sellac.CacheTest do
  use ExUnit.Case, async: true

  test "stores value by key" do
    {:ok, bucket} = Shellac.Cache.start_link
    assert Shellac.Cache.get(bucket, "index.html") == nil

    Shellac.Cache.put(bucket, "index.html", "<p>Hello</p>")
    assert Shellac.Cache.get(bucket, "index.html") == "<p>Hello</p>"
  end
end
