defmodule TodoistIntegrationSpec.TaskFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias TodoistIntegration.IntegrationContent.Task

      def task_factory do
        %Task{
          content: sequence(:external_key, &"Task #{&1}"),
          remote_id: 123
        }
      end
    end
  end
end
