defmodule QrcodeRouterServiceWeb.ServiceRoutingController do
  use QrcodeRouterServiceWeb, :controller
  alias ServicePicker.Entity.AvailableService

  def index(conn, params) do
    destination_service = AvailableService.get_enableds
      |> ServicePicker.pick_service!()

    case [destination_service, params["display"]] do
      [service, _] when service == nil -> render(conn, :index, service: service)
      [service, should_display] when should_display in ["1", 1] -> render(conn, :index, service: service)
      [service, _] -> redirect(conn, external: service.url)
    end
  end

  def show(conn, params) do
    service_kind = params["service_kind"]
    render(conn, :show, %{service_type: service_kind})
  end
end

## Handles ServiceRoutingJson response type
defmodule QrcodeRouterServiceWeb.ServiceRoutingJSON do
  def index(%{service: nil}), do: %{ result: "Nenhum serviço disponível", status: 404 }

  def index(%{service: service_item}) do
    %{
      kind: service_item.kind,
      url: service_item.url,
      redirects_count: service_item.redirects_count,
      enabled: service_item.enabled
    }
  end

  def show(%{service_type: service}) do
    %{service_type: service}
  end
end
