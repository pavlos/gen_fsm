defmodule GenFSM.Mixfile do
  use Mix.Project

  def project do
    [app: :gen_fsm,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: deps,
     description: description]
  end

  def deps do
    [{:ex_doc, ">= 0.11.4", only: [:dev]},
     {:earmark, ">= 0.0.0", only: [:dev]}]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp description do
  """
    Elixir wrapper around Erlang's OTP gen_fsm.
  """
  end

  defp package do
    [# These are the default files included in the package
     files: ["lib", "mix.exs", "README*", "LICENSE",
     maintainers: ["Paul Hieromnimon"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/pavlos/gen_fsm",
              "Docs" => "https://hexdocs.pm/gen_fsm/"}]
  end
end
