defmodule QrcodeRouterServiceWeb.ServiceRoutingController do
  use QrcodeRouterServiceWeb, :controller

  def index(conn, _params) do
    destination_service = QrcodeRouting.route_service()
    # redirect(conn, external: destination_service.url)
    render(conn, :index, service: destination_service)
  end
end

## Handles ServiceRoutingJson response type
defmodule QrcodeRouterServiceWeb.ServiceRoutingJSON do
  alias QrcodeRouting.AvailableService

  def index(%{service: service_item}) do
    Map.from_struct(service_item)
  end
end
