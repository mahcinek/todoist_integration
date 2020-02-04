defmodule TodoistIntegrationSpec.UserFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias TodoistIntegration.Accounts.User

      def user_factory do
        %User{
          email: sequence(:external_key, &"email#{&1}@email.com"),
        }
      end
    end
  end
end
