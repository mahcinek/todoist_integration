# TodoistIntegration

DEPS:
* Elixir `1.9.4`
* Postgresql `> 9.6`

To start your TodoistIntegration server:

  * Install dependencies with `mix deps.get`
  * Fill in your todoist api key in `priv/repo/seeds.exs` in place of `YOUR API CODE HERE`
  * Make sure that `dev.exs` and `test.exs` has right database info for your machine
  * Create and migrate your database with `mix ecto.setup`
  * To run basic implemented tests `mix espec spec`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

You can get your API key to the secure part of the API under `GET localhost:4000/unsecureapi/users`

All of the endpoints under `/api` require Bearer token

Implemented endpoints:

  * `POST /api/synch` 
  * `GET /api/tasks/search` (optional params: name, source) 
  * `PATCH /api/tasks/:task_id` (params: content) 


Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

