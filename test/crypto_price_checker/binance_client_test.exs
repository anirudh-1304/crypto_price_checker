defmodule CryptoPriceChecker.BinanceClientTest do
  use ExUnit.Case

  alias CryptoPriceChecker.BinanceClient
  alias CryptoPriceChecker.MockBinanceServer

  test "subscribes to pairs" do
    assert :ok == BinanceClient.subscribe_binance_stream(["btcusdt", "ethusdt"])
    assert true
  end

  test "processes ticker update" do
    assert :ok == BinanceClient.process_ticker_update(%{"s" => "BTCUSDT", "c" => "50000.00"})
    assert [{"BTCUSDT", 50000.0}] = :ets.lookup(:crypto_price_table, "BTCUSDT")
  end
end
