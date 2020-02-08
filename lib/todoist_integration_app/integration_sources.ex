defmodule TodoistIntegration.IntegrationSources do
  @moduledoc """
  The IntegrationSources context.
  """

  import Ecto.Query, warn: false
  alias TodoistIntegration.Repo
  alias TodoistIntegration.Accounts

  alias TodoistIntegration.IntegrationSources.IntegreationSource

  @doc """
  Returns the list of integration_sources.

  ## Examples

      iex> list_integration_sources()
      [%IntegreationSource{}, ...]

  """
  def list_integration_sources do
    Repo.all(IntegreationSource)
  end

  @doc """
  Gets a single integreation_source.

  Raises `Ecto.NoResultsError` if the Integreation source does not exist.

  ## Examples

      iex> get_integreation_source!(123)
      %IntegreationSource{}

      iex> get_integreation_source!(456)
      ** (Ecto.NoResultsError)

  """
  def get_integreation_source!(id), do: Repo.get!(IntegreationSource, id)

  @doc """
  Creates a integreation_source.

  ## Examples

      iex> create_integreation_source(%{field: value})
      {:ok, %IntegreationSource{}}

      iex> create_integreation_source(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_integreation_source(attrs \\ %{}) do
    %IntegreationSource{}
    |> IntegreationSource.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a integreation_source.

  ## Examples

      iex> update_integreation_source(integreation_source, %{field: new_value})
      {:ok, %IntegreationSource{}}

      iex> update_integreation_source(integreation_source, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_integreation_source(%IntegreationSource{} = integreation_source, attrs) do
    integreation_source
    |> IntegreationSource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a integreation_source.

  ## Examples

      iex> delete_integreation_source(integreation_source)
      {:ok, %IntegreationSource{}}

      iex> delete_integreation_source(integreation_source)
      {:error, %Ecto.Changeset{}}

  """
  def delete_integreation_source(%IntegreationSource{} = integreation_source) do
    Repo.delete(integreation_source)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking integreation_source changes.

  ## Examples

      iex> change_integreation_source(integreation_source)
      %Ecto.Changeset{source: %IntegreationSource{}}

  """
  def change_integreation_source(%IntegreationSource{} = integreation_source) do
    IntegreationSource.changeset(integreation_source, %{})
  end

  def get_tasks(token, integration_source_name) do
    apply(
      "TodoistIntegration.IntegrationSources.Connections." <>
        Macro.camelize(integration_source_name),
      "call",
      token
    )
  end
end
