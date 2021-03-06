defmodule TodoistIntegrationWeb.UserView do
  use TodoistIntegrationWeb, :view
  alias TodoistIntegrationWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email, auth_token: user.auth_token}
  end
end
