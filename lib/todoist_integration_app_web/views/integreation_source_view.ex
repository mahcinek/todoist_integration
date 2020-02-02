defmodule TodoistIntegrationWeb.IntegreationSourceView do
  use TodoistIntegrationWeb, :view
  alias TodoistIntegrationWeb.IntegreationSourceView

  def render("index.json", %{integration_sources: integration_sources}) do
    %{data: render_many(integration_sources, IntegreationSourceView, "integreation_source.json")}
  end

  def render("show.json", %{integreation_source: integreation_source}) do
    %{data: render_one(integreation_source, IntegreationSourceView, "integreation_source.json")}
  end

  def render("integreation_source.json", %{integreation_source: integreation_source}) do
    %{id: integreation_source.id,
      name: integreation_source.name}
  end
end
