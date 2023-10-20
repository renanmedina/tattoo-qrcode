defmodule QrcodeRouterServiceWeb.ServiceRoutingController do
  use QrcodeRouterServiceWeb, :controller

  def index(conn, _params) do
    destination_service = QrcodeRouting.get_enabled_services
      |> QrcodeRouting.pick_service!()
    redirect(conn, external: destination_service.url)
  end

  def show(conn, params) do
    service_kind = params["service_kind"]
    render(conn, :index, %{service_type: service_kind})
  end
end

## Handles ServiceRoutingJson response type
defmodule QrcodeRouterServiceWeb.ServiceRoutingJSON do
  def index(%{service: service_item}) do
    Map.from_struct(service_item)
  end

  def index(%{service_type: service}) do
    %{service_type: service}
  end
end
