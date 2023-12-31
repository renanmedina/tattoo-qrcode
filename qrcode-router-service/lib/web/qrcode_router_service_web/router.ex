defmodule QrcodeRouterServiceWeb.Router do
  use QrcodeRouterServiceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {QrcodeRouterServiceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", QrcodeRouterServiceWeb do
    pipe_through :api

    get "/", ServiceRoutingController, :index
    get "/:service_kind", ServiceRoutingController, :show

    get "/oauth/callback/:service_name", OAuth.CallbackController, :index
  end

  scope "/api/management", QrcodeRouterServiceWeb.Management do
    pipe_through :api

    get "/available_urls", AvailableUrlsController, :index

    get "/available_services", AvailableServicesController, :index
    post "/available_services", AvailableServicesController, :create
    put "/available_services/:kind/toggle_active", AvailableServicesController, :toggle_active
  end

  # Other scopes may use custom stacks.
  # scope "/api", QrcodeRouterServiceWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:qrcode_router_service, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: QrcodeRouterServiceWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
