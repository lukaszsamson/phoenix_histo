defmodule PhoenixHisto.Mixfile do
  use Mix.Project

  @version "1.0.1"

  def project do
    [
      app: :phoenix_histo,
      version: @version,
      elixir: "~> 1.3",
      deps: deps(),
      dialyzer: [plt_local_path: "priv/plts", plt_core_path: "priv/plts"],
      description: description(),
      package: package(),
      name: "PhoenixHisto",
      source_url: "https://github.com/lukaszsamson/phoenix_histo",
      docs: [
        extras: ["README.md"],
        main: "readme",
        source_ref: "v#{@version}",
        source_url: "https://github.com/lukaszsamson/phoenix_histo"
      ]
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:spec_lint, "~> 0.1", only: [:dev, :test], runtime: false},
      {:phoenix, "~> 1.2"},
      {:ex_doc, "~> 0.14", only: :dev}
    ]
  end

  defp description do
    """
    History API fallback plug for web applications with client side routing.
    """
  end

  defp package do
    [
      name: :phoenix_histo,
      files: ["lib", "mix.exs", ".formatter.exs", "README*", "LICENSE*"],
      maintainers: ["Łukasz Samson"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/lukaszsamson/phoenix_histo"}
    ]
  end
end
