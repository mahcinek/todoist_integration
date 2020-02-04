defmodule TodoistIntegrationSpec.Helpers do
  @moduledoc false

  alias TodoistIntegrationSpec.Helpers.Pluck

  defdelegate pluck(collection, keys), to: Pluck
end
