defmodule Sellac.ProxyTest do
  use ExUnit.Case, async: true

  test "#process_url should be localhost:9292/" do
    assert Shellac.Proxy.process_url("/") == "http://localhost:9292/"
  end
end
