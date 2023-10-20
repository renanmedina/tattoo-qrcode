defmodule QrcodeRouterServiceWeb.ServiceRoutingController do
  use QrcodeRouterServiceWeb, :controller
  alias ServicePicker.Entity.AvailableService

  def index(conn, params) do
    destination_service = AvailableService.get_enableds
      |> ServicePicker.pick_service!()

    case params["display"] do
      "1" -> render(conn, :index, service: destination_service)
      _ -> redirect(conn, external: destination_service.url)
    end
  end

  def show(conn, params) do
    service_kind = params["service_kind"]
    render(conn, :index, %{service_type: service_kind})
  end
end

## Handles ServiceRoutingJson response type
defmodule QrcodeRouterServiceWeb.ServiceRoutingJSON do
  def index(%{service: service_item}) do
    %{
      kind: service_item.kind,
      url: service_item.url,
      redirects_count: service_item.redirects_count,
      enabled: service_item.enabled
    }
  end

  def index(%{service_type: service}) do
    %{service_type: service}
  end
end
