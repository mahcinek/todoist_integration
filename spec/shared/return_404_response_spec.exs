defmodule Return404ResponseSpec do
  use ESpec, shared: true
  import Phoenix.ConnTest, only: [assert_error_sent: 2]

  let_overridable([:response])

  it "returns 404 response" do
    assert_error_sent(404, fn ->
      response()
    end)
  end
end
