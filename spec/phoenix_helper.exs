Code.require_file("spec/espec_phoenix_extend.ex")
Code.require_file("spec/shared/return_401_response_spec.exs")

{:ok, _} = Application.ensure_all_started(:ex_machina)

Ecto.Adapters.SQL.Sandbox.mode(TodoistIntegration.Repo, :manual)
