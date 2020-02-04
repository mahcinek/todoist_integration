defmodule Return401ResponseSpec do
  use ESpec, shared: true
  import Phoenix.ConnTest, only: [assert_error_sent: 2]

  let_overridable([:response])

  it "returns 401 response" do
    assert_error_sent(401, fn ->
      response()
    end)
  end
end
