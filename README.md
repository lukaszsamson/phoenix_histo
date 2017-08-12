# PhoenixHisto

A plug for handling client side routing in Phoenix, a.k.a. History Api fallback.

## Rationale

Single page applications use [History Api](https://developer.mozilla.org/en/docs/Web/API/History)
to enable client side routing. This plug allows for handling client side routes on the server
by rewriting requests to `index.html`.

## Requests exempt from rewrite

The fallback algorithm is limited only to certain requests. In particular it will not rewrite if:
- request method is not `GET` or `HEAD`.
- it is a file request, e.g. `"/path/file.ext"`; note that if `PhoenixHisto`
is plugged after `Plug.Static` and we get a file request than most likely the file
does not exist and `404` response will be returned
- the client does not accept `text/html` response MIME type
- the requested path starts with one of the paths in `:blacklist`

## Installation

The package can be installed by adding `phoenix_histo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_histo, "~> 1.0.0"}
  ]
end
```

## Usage

Add plug invocation in your `Endpoint` pipeline just after `Plug.Static`:

```elixir
defmodule MyAppWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :my_app
  ...
  @static_opts [at: "/", from: :my_app, gzip: false]
  plug Plug.Static,
    (@static_opts ++
    [only: ~w(css fonts img js favicon.ico robots.txt manifest.json)])
  plug PhoenixHisto,
    static_opts: @static_opts,
    blacklist: ["/api"]
  ...
end
```

## Options

  - `:index` - path to index.html fallback relative to the dir passed in
`:static_opts` (defaults to `"index.html"`).
  - `:blacklist` - list of path prefixes exempt from fallback algorithm
(defaults to `[]`).
  - `:static_opts` - options to forward to `Plug.Static` (required), refer to
`Plug.Static` docs. Note that `:only` and `:only_matching`
are not respected.

## Documentation
Docs can be found at [https://hexdocs.pm/phoenix_histo](https://hexdocs.pm/phoenix_histo).

## License

PhoenixHisto source code is released under MIT License.
Check LICENSE file for more information.
