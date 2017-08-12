defmodule PhoenixHistoTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule MyPlug do
    use Plug.Builder

    plug PhoenixHisto,
      static_opts: [
        at: "/",
        from: Path.expand("fixtures", __DIR__),
        gzip: false,
      ],
      blacklist: ["/api"]
    plug :passthrough

    defp passthrough(conn, _), do:
      Plug.Conn.send_resp(conn, 404, "Passthrough")
  end

  defp call(conn), do: MyPlug.call(conn, [])

  test "rewrites root request" do
    conn = call(conn(:get, "/"))
    assert conn.status == 200
    assert conn.resp_body =~ "Fixture index"
    assert get_resp_header(conn, "content-type")  == ["text/html"]
  end

  test "rewrites client route and serves index.html" do
    conn = call(conn(:get, "/client/route"))
    assert conn.status == 200
    assert conn.resp_body =~ "Fixture index"
    assert get_resp_header(conn, "content-type")  == ["text/html"]
  end

  test "does not rewrite POST requests" do
    conn = call(conn(:post, "/client/route"))
    assert conn.status == 404
    assert conn.resp_body == "Passthrough"
  end

  test "does not rewrite blacklisted paths" do
    conn = call(conn(:get, "/api/endpoint"))
    assert conn.status == 404
    assert conn.resp_body == "Passthrough"
  end

  test "does not rewrite if text/html not accepted" do
    conn = conn(:get, "/client/route")
    |> put_req_header("accept", "application/json")
    |> call
    assert conn.status == 404
    assert conn.resp_body == "Passthrough"
  end

  test "does not rewrite file requests" do
    conn = call(conn(:get, "/client/route.txt"))
    assert conn.status == 404
    assert conn.resp_body == "Passthrough"
  end

end
