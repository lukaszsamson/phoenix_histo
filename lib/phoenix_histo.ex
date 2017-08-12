defmodule PhoenixHisto do
  @moduledoc """
  A plug for handling client side routing ith History Api
  It rewrites requests for client side routes to `index.html` file.
  ## Requests exempt from fallback
  The fallback algorithm is limited only to certain requests. In particular
  it will not fallback if:
    * request method is not `GET` or `HEAD`.
    * it is a file request, e.g. `"/path/file.ext"`; not that if `PhoenixHisto`
      is plugged after `Plug.Static` and we get a file request than most likely
      the file does not exist and `404` response will be returned
    * the client does not accept `text/html` response MIME type
    * the requested path starts with one of the paths in `:blacklist`
  ## Options
    * `:index` - path to index.html fallback relative to the dir passed in
      `:static_opts` (defaults to `"index.html"`).
    * `:blacklist` - list of path prefixes exempt from fallback algorithm
      (defaults to `[]`).
    * `:static_opts` - options to forward to `Plug.Static` (required), refer to
      `Plug.Static` docs`. Note that `:only` and `:only_matching`
      are not respected.
  ## Examples
  The best place to mount this plug is in `Phoenix.Endpoint`, just after all
  `Plug.Static` entries:
      defmodule MyAppWeb.Endpoint do
        use Phoenix.Endpoint, otp_app: :my_app
        @static_opts [at: "/", from: :my_app, gzip: false]
        plug Plug.Static,
          (@static_opts ++
          [only: ~w(css fonts img js favicon.ico robots.txt manifest.json)])
        plug PhoenixHisto,
          static_opts: @static_opts,
          blacklist: ["/api"]
        ...
      end
  """

  import Phoenix.Controller

  @behaviour Plug
  @allowed_methods ~w(GET HEAD)

  def init(opts) do
    index = Keyword.get(opts, :index, "index.html")

    static_opts = opts
    |> Keyword.fetch!(:static_opts)
    |> Keyword.put(:only, [index])
    |> Keyword.delete(:only_matching)
    |> Plug.Static.init

    %{
      static_opts: static_opts,
      blacklist: Keyword.get(opts, :blacklist, []),
      index_path: index |> String.split("/")
    }
  end

  defp html_accepted?(conn) do
    try do
      _ = accepts(conn, ["html"])
      true
    rescue
      Phoenix.NotAcceptableError -> false
    end
  end

  defp file_request?(conn) do
    case conn.path_info |> Enum.at(-1) do
      nil -> false
      last -> String.contains?(last, ".")
    end
  end

  defp blacklisted?(conn, blacklist) do
    blacklist
    |> Enum.any?(& conn.request_path |> String.starts_with?(&1))
  end

  def call(conn, %{static_opts: static_opts, blacklist: blacklist, index_path: index_path}) do
    if conn.method in @allowed_methods
      and not file_request?(conn)
      and html_accepted?(conn)
      and not blacklisted?(conn, blacklist) do
      %Plug.Conn{conn | path_info: index_path}
      |> Plug.Static.call(static_opts)
    else
      conn
    end
  end

end
