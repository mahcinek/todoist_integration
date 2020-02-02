defmodule TodoistIntegrationWeb.IntegreationSourceControllerTest do
  use TodoistIntegrationWeb.ConnCase

  alias TodoistIntegration.IntegrationSources
  alias TodoistIntegration.IntegrationSources.IntegreationSource

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:integreation_source) do
    {:ok, integreation_source} = IntegrationSources.create_integreation_source(@create_attrs)
    integreation_source
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all integration_sources", %{conn: conn} do
      conn = get(conn, Routes.integreation_source_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create integreation_source" do
    test "renders integreation_source when data is valid", %{conn: conn} do
      conn =
        post(conn, Routes.integreation_source_path(conn, :create),
          integreation_source: @create_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.integreation_source_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.integreation_source_path(conn, :create),
          integreation_source: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update integreation_source" do
    setup [:create_integreation_source]

    test "renders integreation_source when data is valid", %{
      conn: conn,
      integreation_source: %IntegreationSource{id: id} = integreation_source
    } do
      conn =
        put(conn, Routes.integreation_source_path(conn, :update, integreation_source),
          integreation_source: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.integreation_source_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      integreation_source: integreation_source
    } do
      conn =
        put(conn, Routes.integreation_source_path(conn, :update, integreation_source),
          integreation_source: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete integreation_source" do
    setup [:create_integreation_source]

    test "deletes chosen integreation_source", %{
      conn: conn,
      integreation_source: integreation_source
    } do
      conn = delete(conn, Routes.integreation_source_path(conn, :delete, integreation_source))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.integreation_source_path(conn, :show, integreation_source))
      end
    end
  end

  defp create_integreation_source(_) do
    integreation_source = fixture(:integreation_source)
    {:ok, integreation_source: integreation_source}
  end
end
