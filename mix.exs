defmodule Blitzy.MixProject do
  use Mix.Project

  def project do
    [
      app: :blitzy,
      version: "0.1.0",
      elixir: "~> 1.7",
      escript: [main_module: Blitzy.CLI], # when you call mix escript.build
                                          # to generate the Blitzy command-line program.
                                          # The module pointed to by main_module
                                          #  is expected to have a main/1 function
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison, :timex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
        {:httpoison, "~> 0.9.0"}, # http client
        {:timex, "~> 3.0"},       # date|time library
        {:tzdata, "~> 0.1.8", override: true} # play with escripts
    ]
  end
end
