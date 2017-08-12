defmodule PhoenixHisto.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix_histo,
      version: "0.1.0",
      elixir: "~> 1.3",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "PhoenixHisto",
      source_url: "https://github.com/lukaszsamson/phoenix_histo",
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.2"},
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
      files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      maintainers: ["Łukasz Samson"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/lukaszsamson/phoenix_histo"},
    ]
  end
end
