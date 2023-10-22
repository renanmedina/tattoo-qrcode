defmodule QrcodeRouterServiceWeb.ServiceRoutingController do
  use QrcodeRouterServiceWeb, :controller
  alias ServicePicker.Entity.AvailableService

  def index(conn, params) do
    case is_tattoo_session_id?(params["session_id"]) do
      true ->
        destination_service = AvailableService.get_enableds
          |> ServicePicker.pick_service!()
        case [destination_service, params["display"]] do
          [service, _] when service == nil -> render(conn, :index, service: service)
          [service, should_display] when should_display in ["1", 1] -> render(conn, :index, service: service)
          [service, _] -> redirect(conn, external: service.url)
        end
      false -> render(conn, :index, %{})
    end
  end

  def show(conn, params) do
    try do
      service_kind = params["service_kind"]
      redirect_url = get_redirect_url(service_kind)
      redirect(conn, external: redirect_url)
    rescue
      e in [Music.MusicUrlChooserException, Music.MusicUrlNotAvailableException] ->
        render(conn, :show, %{status: 404, message: e.message})
      e -> render(conn, :show, %{status: 500, message: e.message})
    end
  end

  defp get_redirect_url("music_and_playlists"), do: MusicChooser.pick_one_url!
  defp get_redirect_url(_), do: raise "Service not implemented yet"

  defp is_tattoo_session_id?(id) do
    case Application.get_env(:qrcode_router_service, :env) do
      :prod ->
        tattoo_id = Application.fetch_env!(:qrcode_router_service, :tattoo_session_id)
        tattoo_id == id
      _ -> true
    end
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
  def index(%{}), do: %{}

  def show(%{status: status, message: msg}) do
    %{
      status: status,
      message: msg
    }
  end
end
