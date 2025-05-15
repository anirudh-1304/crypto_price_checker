defmodule CryptoPriceChecker.Repo do
  use Ecto.Repo,
    otp_app: :crypto_price_checker,
    adapter: Ecto.Adapters.Postgres
end
