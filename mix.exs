defmodule Quoil.Mixfile do
  use Mix.Project

  def project do
    [app: :quoil,
     version: "0.4.1",
     elixir: "~> 1.0",
     test_coverage: [tool: Coverex.Task],
     escript: escript_config,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:coverex, "~> 1.3.0"},
      {:gen_icmp, github: "msantos/gen_icmp"}
    ]
  end

  defp escript_config do
    [main_module: Quoil.CLI]
  end
end
