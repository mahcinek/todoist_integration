defmodule TodoistIntegrationSpec.IntegrationSourceUserFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias TodoistIntegration.IntegrationSourceUsers.IntegrationSourceUser

      def integration_source_user_factory do
        %IntegrationSourceUser{
          source_api_key: "key"
        }
      end
    end
  end
end
