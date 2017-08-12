defmodule PhoenixHisto.Mixfile do
  use Mix.Project

  @version "1.0.0"

  def project do
    [
      app: :phoenix_histo,
      version: @version,
      elixir: "~> 1.3",
      deps: deps(),
      description: description(),
      package: package(),
      name: "PhoenixHisto",
      source_url: "https://github.com/lukaszsamson/phoenix_histo",
      docs: [extras: ["README.md"], main: "readme",
            source_ref: "v#{@version}",
            source_url: "https://github.com/elixir-plug/plug"]
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:phoenix, "~> 1.2"},
      {:ex_doc, "~> 0.14", only: :docs},
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
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Łukasz Samson"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/lukaszsamson/phoenix_histo"},
    ]
  end
end
