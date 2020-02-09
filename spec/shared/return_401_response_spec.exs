defmodule Return401ResponseSpec do
  use ESpec, shared: true
  let_overridable([:response])
  let(:json_body, do: response().resp_body |> Jason.decode!())

  it "returns status 401" do
    expect(response().status |> to(be(401)))
  end

  it "returns meaningful error message" do
    expect(json_body() |> to(eq(%{"message" => "unauthenticated"})))
  end
end
