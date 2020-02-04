defmodule ESpec.Phoenix.Extend do
  def model do
    quote do
      alias TodoistIntegration.Repo
    end
  end

  def controller do
    quote do
      alias TodoistIntegration
      import TodoistIntegrationWeb.Router.Helpers

      @endpoint TodoistIntegrationWeb.Endpoint
    end
  end

  def view do
    quote do
      import TodoistIntegrationWeb.Router.Helpers
    end
  end

  def channel do
    quote do
      alias TodoistIntegration.Repo

      @endpoint TodoistIntegrationWeb.Endpoint
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
