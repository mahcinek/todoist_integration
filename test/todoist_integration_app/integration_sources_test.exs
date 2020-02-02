defmodule TodoistIntegration.IntegrationSourcesTest do
  use TodoistIntegration.DataCase

  alias TodoistIntegration.IntegrationSources

  describe "integration_sources" do
    alias TodoistIntegration.IntegrationSources.IntegreationSource

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def integreation_source_fixture(attrs \\ %{}) do
      {:ok, integreation_source} =
        attrs
        |> Enum.into(@valid_attrs)
        |> IntegrationSources.create_integreation_source()

      integreation_source
    end

    test "list_integration_sources/0 returns all integration_sources" do
      integreation_source = integreation_source_fixture()
      assert IntegrationSources.list_integration_sources() == [integreation_source]
    end

    test "get_integreation_source!/1 returns the integreation_source with given id" do
      integreation_source = integreation_source_fixture()
      assert IntegrationSources.get_integreation_source!(integreation_source.id) == integreation_source
    end

    test "create_integreation_source/1 with valid data creates a integreation_source" do
      assert {:ok, %IntegreationSource{} = integreation_source} = IntegrationSources.create_integreation_source(@valid_attrs)
      assert integreation_source.name == "some name"
    end

    test "create_integreation_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = IntegrationSources.create_integreation_source(@invalid_attrs)
    end

    test "update_integreation_source/2 with valid data updates the integreation_source" do
      integreation_source = integreation_source_fixture()
      assert {:ok, %IntegreationSource{} = integreation_source} = IntegrationSources.update_integreation_source(integreation_source, @update_attrs)
      assert integreation_source.name == "some updated name"
    end

    test "update_integreation_source/2 with invalid data returns error changeset" do
      integreation_source = integreation_source_fixture()
      assert {:error, %Ecto.Changeset{}} = IntegrationSources.update_integreation_source(integreation_source, @invalid_attrs)
      assert integreation_source == IntegrationSources.get_integreation_source!(integreation_source.id)
    end

    test "delete_integreation_source/1 deletes the integreation_source" do
      integreation_source = integreation_source_fixture()
      assert {:ok, %IntegreationSource{}} = IntegrationSources.delete_integreation_source(integreation_source)
      assert_raise Ecto.NoResultsError, fn -> IntegrationSources.get_integreation_source!(integreation_source.id) end
    end

    test "change_integreation_source/1 returns a integreation_source changeset" do
      integreation_source = integreation_source_fixture()
      assert %Ecto.Changeset{} = IntegrationSources.change_integreation_source(integreation_source)
    end
  end
end
