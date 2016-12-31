defmodule Stone.Mixfile do
  use Mix.Project

  def project do
    [
      app: :stone,
      name: "Stone",
      version: "0.2.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      source_url: "https://github.com/MillionIntegrals/stone",
      package: [
        maintainers: ["Million Integrals"],
        licenses: ["MIT"],
        links: %{
          "Github" => "https://github.com/MillionIntegrals/stone"
        }
      ],
      description: "Metaprogramming utilities for the Elixir language.",
      docs: [
        extras: ["README.md": [title: "README"]],
        main: "Stone",
      ]
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, "~> 0.14", only: :dev}]
  end
end
