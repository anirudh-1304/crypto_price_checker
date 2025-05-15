defmodule CryptoPriceChecker.BinanceClientTest do
  use ExUnit.Case

  alias CryptoPriceChecker.BinanceClient

  test "Successfully subscribes to pairs and updates ETS table" do
    assert :ok == BinanceClient.subscribe_binance_stream(["btcusdt", "ethusdt"])
    Process.sleep(1000)
    assert 2 == length(:ets.tab2list(:crypto_price_table))
    assert [{"BTCUSDT", _}] = :ets.lookup(:crypto_price_table, "BTCUSDT")
    assert [{"ETHUSDT", _}] = :ets.lookup(:crypto_price_table, "ETHUSDT")
  end
end
