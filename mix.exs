defmodule LiveNest.MixProject do
    use Mix.Project
  
    def project do
      [
        app: :live_nest,
        version: "0.1.0",
        elixir: "~> 1.15",
        elixirc_paths: elixirc_paths(Mix.env()),
        start_permanent: Mix.env() == :prod,
        deps: deps(),
        package: package(),
        description: "A robust framework for architecting sophisticated web applications with Phoenix LiveView.",
        docs: [
          main: "LiveNest",
          extras: ["README.md"]
        ]
      ]
    end

    defp elixirc_paths(:test), do: ["lib", "test/support", "test/demo"]
    defp elixirc_paths(_), do: ["lib"]
  
    def application do
      [
        mod: {LiveNest.Support.TestApplication, []},
        extra_applications: [:logger]
      ]
    end
  
    defp deps do
      [
        {:phoenix, "~> 1.7"},
        {:phoenix_live_view, "~> 1.0.0"},
        {:floki, ">= 0.30.0", only: :test},
        {:plug_cowboy, "~> 2.6", only: :test},
        {:ex_doc, "~> 0.29", only: :dev, runtime: false},
        {:jason, "~> 1.0"}
      ]
    end
  
    defp package do
      [
        files: ~w(lib mix.exs README.md LICENSE),
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/eyra/live_nest"}
      ]
    end
  end