defmodule QrcodeRouterService.Repo do
  use Ecto.Repo,
    otp_app: :qrcode_router_service,
    adapter: Ecto.Adapters.Postgres
end
