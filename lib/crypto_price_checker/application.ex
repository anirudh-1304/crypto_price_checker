defmodule CryptoPriceChecker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CryptoPriceCheckerWeb.Telemetry,
      CryptoPriceChecker.Repo,
      {CryptoPriceChecker.BinanceClient, []},
      {DNSCluster,
       query: Application.get_env(:crypto_price_checker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CryptoPriceChecker.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CryptoPriceChecker.Finch},
      # Start a worker by calling: CryptoPriceChecker.Worker.start_link(arg)
      # {CryptoPriceChecker.Worker, arg},
      # Start to serve requests, typically the last entry
      CryptoPriceCheckerWeb.Endpoint
    ]

    # Initialize ETS table
    :ets.new(:crypto_price_table, [:set, :public, :named_table])
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CryptoPriceChecker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CryptoPriceCheckerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
