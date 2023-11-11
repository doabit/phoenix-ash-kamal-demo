defmodule AshDemoWeb.HealthCheck do
  import Plug.Conn
  @behaviour Plug
  def init(opts), do: opts

  def call( %{path_info: ["up"]} = conn, _opts) do
    conn
    |> send_resp(200, "ok")
    |> halt()
  end

  def call(conn, _opts), do: conn
end
