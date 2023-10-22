defmodule QrcodeRouterServiceWeb.Management.AvailableServicesController do
  use QrcodeRouterServiceWeb, :controller
  alias ServicePicker.Entity.AvailableService

  def index(conn, params) do
    services = case params["enabled"] do
      param_value when param_value in[1, "1"] -> AvailableService.get_enableds
      param_value when param_value in[0, "0"] -> AvailableService.get_disableds
      _ -> AvailableService.get_all
    end

    render(conn, :index, %{services_list: services})
  end

  def create(conn, params) do
    try do
      case {params["kind"], params["name"], params["url"], params["is_enabled"]} do
        {kind, url, name, is_enabled} when kind != nil and url != nil and name != nil ->
          {:ok, new_service} = AvailableService.create(kind, url, name, is_enabled)
          render(conn, :show, %{service_item: new_service})
        _ ->
          raise "Parametros inválidos, envie a requisição com os seguintes campos para adicionar um novo serviço: kind, name, url"
      end
    rescue
      e in Ecto.ConstraintError ->
        conn |> put_status(422)
        render(conn, :show, %{status: 422, message: "Serviço já cadastrado"})
      e ->
        conn |> put_status(422)
        render(conn, :show, %{status: 422, message: e.message})
    end
  end

  def toggle_active(conn, params) do
    service_kind = params["kind"]
    case AvailableService.get_by(service_kind) do
      service when service != nil ->
        {:ok, updated_status} = AvailableService.toggle_active(service)
        conn |> put_status(200)
        render(conn, :show, %{service_item: service})
      _ ->
        conn |> put_status(404)
        render(conn, :show, %{status: 404, message: "Serviço do tipo #{service_kind} não encontrado"})
    end
  end

end

## Handles AvailableServicesJSON response type
defmodule QrcodeRouterServiceWeb.Management.AvailableServicesJSON do
  def index(%{services_list: services_list}) do
    services_list
      |> Enum.map(&(to_json_services(&1)))
  end

  def show(%{service_item: service}) do
    %{
      status: 200,
      message: "Serviço adicionado com sucesso",
      service_data: to_json_services(service)
    }
  end

  def show(%{status: status, message: msg}) do
    %{
      status: status,
      message: msg
    }
  end

  def to_json_services(available_service) do
    %{
      id: available_service.id,
      service_type: available_service.kind,
      name: available_service.name,
      url: available_service.url,
      last_redirected_at: available_service.last_redirected_at,
      is_enabled: available_service.enabled
    }
  end
end
