defmodule QrcodeRouterServiceWeb.ServiceRoutingController do
  use QrcodeRouterServiceWeb, :controller

  def index(conn, _params) do
    destination_service = QrcodeRouting.route_service()
    redirect(conn, external: destination_service[:url])
  end
end
