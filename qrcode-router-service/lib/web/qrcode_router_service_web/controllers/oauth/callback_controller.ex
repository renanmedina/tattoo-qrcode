defmodule QrcodeRouterServiceWeb.OAuth.CallbackController do
  use QrcodeRouterServiceWeb, :controller
  alias Music.SpotifyAuth
  alias Application.Entity.SettingItem

  def index(conn, params) do
    service_name = params["service_name"]
    case {service_name, params["code"]} do
      {service_name, nil} when is_bitstring(service_name) -> redirect(conn, external: SpotifyAuth.get_authorize_url())
      {service_name, code} when is_bitstring(service_name) and is_bitstring(code) ->
        result = handle_callback(service_name, params)
        case result do
          [:ok, access_token] -> render(conn, :index, result: %{status: 200, token: access_token})
          [:error, _] -> render(conn, :index, result: %{status: 500, message: "Failed to retrieve token based on authorization code for #{service_name}"})
        end
    end
  end

  defp handle_callback(service_name, params) when service_name == "spotify" do
    case params["code"] do
      authorization_code when is_bitstring(authorization_code) ->
        access_token = SpotifyAuth.get_access_token(authorization_code)
        SettingItem.save_spotify_token(access_token)
        [:ok, access_token]
      _ -> [:error, nil]
    end
  end
end

defmodule QrcodeRouterServiceWeb.OAuth.CallbackJSON do
  def index(%{result: data}), do: data
end
