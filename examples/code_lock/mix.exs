defmodule CodeLock.Mixfile do
  use Mix.Project

  def project do
    [app: :code_lock,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:gen_fsm, "~> 0.1"}]
  end
end
