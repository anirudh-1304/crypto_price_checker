defmodule CryptoPriceChecker.BinanceClient do
  use WebSockex

  require Logger

  def start_link(_args) do
    WebSockex.start_link("wss://stream.binance.com:9443/ws/stream", __MODULE__, %{},
      name: __MODULE__
    )
  end

  def init(state) do
    Logger.info("WebSocket connection initialized.")
    {:ok, state}
  end

  def subscribe_binance_stream(pairs) do
    payload = %{
      id: 1,
      params: Enum.map(pairs, &(&1 <> "@ticker")),
      method: "SUBSCRIBE"
    }

    WebSockex.send_frame(__MODULE__, {:text, Jason.encode!(payload)})
  end

  def handle_frame({:text, message}, state) do
    case Jason.decode(message) do
      {:ok, %{"data" => data}} ->
        process_ticker_update(data)

      {:error, _reason} ->
        Logger.error("Failed to parse message: #{message}")
    end

    {:ok, state}
  end

  def process_ticker_update(%{"s" => symbol, "c" => price}) do
    :ets.insert(:crypto_price_table, {symbol, String.to_float(price)})
    Logger.info("Successfully Updated #{symbol} price to #{price}")
  end

  def process_ticker_update(_), do: :ok

  def handle_info(:reconnect, state) do
    Logger.info("Reconnecting to WebSocket...")
    {:close, state}
  end

  def handle_info(_message, state) do
    Logger.warning("Unhandled message received.")
    {:ok, state}
  end

  def handle_disconnect(reason, state) do
    Logger.warning("WebSocket disconnected: #{inspect(reason)}. Attempting reconnect...")
    {:reconnect, state}
  end
end
