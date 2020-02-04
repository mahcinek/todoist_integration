defmodule TodoistIntegrationSpec.Helpers.Pluck do
  @moduledoc false

  def pluck(collection, key) when is_atom(key) or is_binary(key) do
    pluck(collection, [key])
  end

  def pluck(collection, keys) when is_list(keys) do
    collection
    |> Enum.map(fn element -> Map.take(element, keys) end)
  end
end
