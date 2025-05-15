defmodule CryptoPriceCheckerWeb.Router do
  use CryptoPriceCheckerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CryptoPriceCheckerWeb do
    pipe_through :api

    get "/average_price", CryptoPriceController, :average_price
    post "/subscribe_to_pairs", CryptoPriceController, :subscribe_to_pairs
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:crypto_price_checker, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CryptoPriceCheckerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
