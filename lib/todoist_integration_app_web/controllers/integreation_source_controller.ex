defmodule TodoistIntegrationWeb.IntegreationSourceController do
  use TodoistIntegrationWeb, :controller

  alias TodoistIntegration.IntegrationSources
  alias TodoistIntegration.IntegrationSources.IntegreationSource

  action_fallback TodoistIntegrationWeb.FallbackController

  def index(conn, _params) do
    integration_sources = IntegrationSources.list_integration_sources()
    render(conn, "index.json", integration_sources: integration_sources)
  end

  def create(conn, %{"integreation_source" => integreation_source_params}) do
    with {:ok, %IntegreationSource{} = integreation_source} <- IntegrationSources.create_integreation_source(integreation_source_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.integreation_source_path(conn, :show, integreation_source))
      |> render("show.json", integreation_source: integreation_source)
    end
  end

  def show(conn, %{"id" => id}) do
    integreation_source = IntegrationSources.get_integreation_source!(id)
    render(conn, "show.json", integreation_source: integreation_source)
  end

  def update(conn, %{"id" => id, "integreation_source" => integreation_source_params}) do
    integreation_source = IntegrationSources.get_integreation_source!(id)

    with {:ok, %IntegreationSource{} = integreation_source} <- IntegrationSources.update_integreation_source(integreation_source, integreation_source_params) do
      render(conn, "show.json", integreation_source: integreation_source)
    end
  end

  def delete(conn, %{"id" => id}) do
    integreation_source = IntegrationSources.get_integreation_source!(id)

    with {:ok, %IntegreationSource{}} <- IntegrationSources.delete_integreation_source(integreation_source) do
      send_resp(conn, :no_content, "")
    end
  end
end
