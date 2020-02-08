# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TodoistIntegration.Repo.insert!(%TodoistIntegration.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
integration_source = %TodoistIntegration.IntegrationSources.IntegreationSource{name: "Todoist"}
integration_source = TodoistIntegration.Repo.insert!(integration_source)

integration_source_user = %TodoistIntegration.IntegrationSourceUsers.IntegrationSourceUser{
  source_api_key: "e06f7d4e01bd7b5216201e2f6340ba92277aa5d4",
  integration_source: integration_source
}

user = %TodoistIntegration.Accounts.User{
  email: "test@email.com",
  integration_source_users: [integration_source_user]
}

TodoistIntegration.Repo.insert!(user)
