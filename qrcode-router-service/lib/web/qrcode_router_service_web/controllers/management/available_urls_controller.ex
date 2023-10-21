defmodule QrcodeRouterServiceWeb.Management.AvailableUrlsController do
  use QrcodeRouterServiceWeb, :controller
  alias Application.Entity.AvailableUrl

  def index(conn, params) do
    urls = case {params["service"]} do
      {service_name} when service_name != nil -> AvailableUrl.get_all(%{service_kind: service_name})
      _ -> AvailableUrl.get_all()
    end

    render(conn, :index, urls: urls)
  end
end

## Handles ServiceRoutingJson response type
defmodule QrcodeRouterServiceWeb.Management.AvailableUrlsJSON do
  def index(%{urls: urls}) do
    urls
      |> Enum.map(&(to_json_url(&1)))
  end

  def to_json_url(url_item) do
    %{
      id: url_item.id,
      url: url_item.url,
      url_type: url_item.kind,
      service_type: url_item.service_kind,
      is_enabled: url_item.enabled
    }
  end
end
