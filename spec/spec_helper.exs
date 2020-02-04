ESpec.configure fn(config) ->
  config.before fn(_tags) ->
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TodoistIntegration.Repo)
  end

  config.finally fn(_shared) ->
    Ecto.Adapters.SQL.Sandbox.checkin(TodoistIntegration.Repo, [])
  end
end
{:ok, _} = Application.ensure_all_started(:ex_machina)
Code.require_file("spec/phoenix_helper.exs")
