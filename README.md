# CryptoPriceChecker

This application allows to subscribe to a pair of crypto and also fetch the average prices of those pairs.
The application fetches the prices from the binance ticker streams 
It uses **Elixir** with **Phoenix** for the backend and exposes endpoints for interaction.

---

## Features

### 1. Subscribe to crypto pairs
- We can subscribe to crypto pairs for there prices from binance stream tickers

### 2. Get average price
- Get average prices for the crypto pairs we subscribe to

---

## Installation

### Prerequisites
- Elixir and Erlang installed
- Phoenix Framework

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/anirudh-1304/crypto_price_checker.git
   cd crypto_price_checker
   ```
2. Install dependencies:
   ```bash
   mix deps.get
   ```
3. Create and migrate the database:
   ```bash
   mix ecto.create
   ```
4. Start the Phoenix server:
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
   ```bash
   mix phx.server
   ```
   Now you can visit [`localhost:4000`](http://localhost:4000/api/average_price) from your browser.

---

## API Endpoints

### **Base URL**
`http://localhost:4000/api/average_price`

### Request examples

#### **Subscribe to crypto pairs**
- **POST** `/api/subscribe_to_pairs`
- **Request Body**:
  ```json
  {"pairs": ["btcusdt", "ethusdt"]}
  ```
- **Curl Request for testing this**:
  ```
  curl -X POST http://localhost:4000/api/subscribe_to_pairs \
  -H "Content-Type: application/json" \
  -d '{"pairs": ["btcusdt", "ethusdt"]}'
  ```
- **Response**:
  ```
  {"message":"Subscribed to pairs successfully.","status":"success"}
  ```

#### **Get average prices for crypto pair**
- **GET** `/api/average_price`
- **Curl Request for testing this**:
  ```
  curl -X GET http://localhost:4000/api/average_price
  ```
- **Response**:
  ```
  {"average_price":53188.909999999996}
  ```

---

## Database Schema

### ETS Table

#### **crypto_price_table**
| Column         | Type    | Description                     |
|----------------|---------|---------------------------------|
| symbol         | String  | Crypto symbol                   |
| price          | Float   | Price for crypto                |

---

## Tests

Run the test suite using:
```bash
mix test
```

## Test via browser

1. Run the server on terminal inside root directly of project: mix phx.server
2. Run the Curl command for subscribing as given above
3. Run the following command on broswer: http://localhost:4000/api/average_price
---
