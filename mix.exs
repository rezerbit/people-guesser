defmodule PeopleGuesser.MixProject do
  use Mix.Project

  def project do
    [
      app: :people_guesser,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {PeopleGuesser, []},
      extra_applications: [:logger, :hound]
    ]
  end

  defp deps do
    [
      {:hound, "~> 1.0"}
    ]
  end
end
