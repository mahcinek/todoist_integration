defmodule TodoistIntegrationSpec.IntegrationSourceFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      TodoistIntegration.IntegrationContent.Task

      def integration_source_factory do
        %Task{
          name: sequence(:external_key, &"Task #{&1}"),
          remote_id: sequence(:external_key, &1),
        }
      end
    end
  end
end
