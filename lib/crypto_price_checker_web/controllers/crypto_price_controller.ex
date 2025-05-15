defmodule CryptoPriceCheckerWeb.CryptoPriceController do
  use CryptoPriceCheckerWeb, :controller

  alias CryptoPriceChecker.BinanceClient

  def average_price(conn, _params) do
    prices = :ets.tab2list(:crypto_price_table)
    price_sum = Enum.map(prices, fn {_symbol, price} -> price end) |> Enum.sum()
    avg_price = price_sum / max(1, length(prices))

    json(conn, %{average_price: avg_price})
  end

  def subscribe_to_pairs(conn, %{"pairs" => pairs}) when is_list(pairs) do
    case BinanceClient.subscribe_binance_stream(pairs) do
      :ok ->
        json(conn, %{status: "success", message: "Subscribed to pairs successfully."})

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{status: "error", message: "Failed to subscribe.", reason: inspect(reason)})
    end
  end

  def subscribe_to_pairs(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{status: "error", message: "Invalid parameters. 'pairs' must be a list."})
  end
end
