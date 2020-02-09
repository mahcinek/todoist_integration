defmodule UserControllerSpec do
  use ESpec.Phoenix, controller: TodoistIntegrationWeb.UserController

  import TodoistIntegrationSpec.Factory
  import TodoistIntegrationSpec.Helpers, only: [pluck: 2]

  let(:conn, do: build_conn())

  describe "index /unsecureapi/users" do
    let(:json_body, do: response() |> json_response(200))
    let(:response_users, do: json_body() |> Map.get("data"))

    describe "when there is no auth key provided" do
      let :response do
        conn() |> get(user_path(conn(), :index))
      end

      let! :expected_users do
        insert_list(2, :user)
      end

      it "returns status 200" do
        expect(response().status |> to(be(200)))
      end

      it "returns right users data" do
        expect(
          response_users()
          |> pluck([:id, :email])
          |> to(eql(expected_users() |> pluck(["id", "email"])))
        )
      end

      it "returns not empty auth_tokens" do
        expect(
          response_users()
          |> pluck(["auth_token"])
          |> List.first()
          |> Map.fetch!("auth_token")
          |> not_to(be_empty()))
      end
    end
  end
end
