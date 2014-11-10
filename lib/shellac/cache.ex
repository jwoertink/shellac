defmodule Shellac.Cache do

  @doc """
    Boot up the bucket
  """
  def start_link do
    {:ok, bucket} = Agent.start_link fn -> HashDict.new end
  end

  @doc """
    Get the value from `bucket` by `key`
  """
  def get(bucket, key) do
    Agent.get(bucket, &HashDict.get(&1, key))
  end

  @doc """
    Update `bucket` with `value` by `key`
  """
  def put(bucket, key, value) do
    Agent.update(bucket, &HashDict.put(&1, key, value))
  end
end
