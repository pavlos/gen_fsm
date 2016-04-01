defmodule GenFSM.Mixfile do
  use Mix.Project

  def project do
    [app: :gen_fsm,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: [],
     description: description]
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
     maintainers: ["Paul Hierommnimon"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/pavlos/gen_fsm",
              "Docs" => "https://github.com/pavlos/gen_fsm"}]
  end
end