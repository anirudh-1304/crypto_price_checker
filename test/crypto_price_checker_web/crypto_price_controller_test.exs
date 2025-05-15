defmodule CryptoPriceCheckerWeb.PriceControllerTest do
  use CryptoPriceCheckerWeb.ConnCase

  test "GET /api/average_price returns average price", %{conn: conn} do
    :ets.insert(:crypto_price_table, {"BTCUSDT", 50000.0})
    :ets.insert(:crypto_price_table, {"ETHUSDT", 2000.0})

    conn = get(conn, "/api/average_price")
    assert json_response(conn, 200)["average_price"] == 26000.0
  end

  test "POST /api/subscribe_to_pairs subscribes succesfully and we get the average price", %{
    conn: conn
  } do
    conn = post(conn, "/api/subscribe_to_pairs", %{pairs: ["btcusdt", "ethusdt"]})

    assert %{"message" => "Subscribed to pairs successfully.", "status" => "success"} ==
             json_response(conn, 200)

    Process.sleep(1000)
    conn = get(conn, "/api/average_price")
    assert assert not is_nil(json_response(conn, 200)["average_price"])
  end

  test "POST /api/subscribe_to_pairs subscribes works even with Uppercase values", %{conn: conn} do
    conn = post(conn, "/api/subscribe_to_pairs", %{pairs: ["BTCUSDT", "ETHUSDT"]})

    assert %{"message" => "Subscribed to pairs successfully.", "status" => "success"} ==
             json_response(conn, 200)

    Process.sleep(1000)
    conn = get(conn, "/api/average_price")
    assert assert not is_nil(json_response(conn, 200)["average_price"])
  end
end
