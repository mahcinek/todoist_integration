defmodule TodoistIntegrationSpec.IntegreationSourceFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias TodoistIntegration.IntegrationSources.IntegreationSource

      def integration_source_factory do
        %IntegreationSource{
          name: sequence(:external_key, &"integration source #{&1}"),
        }
      end
    end
  end
end
