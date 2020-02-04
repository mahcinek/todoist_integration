defmodule TodoistIntegrationSpec.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: TodoistIntegration.Repo

  use TodoistIntegrationSpec.{
    UserFactory
    IntegrationSourceFactory
    TaskFactory
  }
end
