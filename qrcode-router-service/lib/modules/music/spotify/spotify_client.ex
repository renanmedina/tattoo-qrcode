defmodule Music.SpotifyClient do
  alias Music.SpotifyAuth.AccessTokenInfo
  alias Music.SpotifyClient.RecentlyPlayedSong

  @api_url "https://api.spotify.com/v1/me"

  def get_playlists(client_token) do

  end

  def get_recent_played_songs(access_token) do
    response = make_request("/player/recently-played", access_token)
    response |> parse_response |> pluck_items |> Enum.map(&(RecentlyPlayedSong.from_map(&1)))
  end

  defp pluck_items(response), do: response["items"]

  defp make_recent_songs(response_json) do
    response_json
  end

  # defp make_request(path, params, access_token), do: HTTPoison.get("#{build_api_url(path)}?#{URI.encode_query(params)}", build_headers(access_token))
  defp make_request(path, access_token), do: HTTPoison.get(build_api_url(path), build_headers(access_token))
  defp parse_response({:ok, %HTTPoison.Response{body: body_data, status_code: 200}}), do: body_data |> Jason.decode!
  defp parse_response(_), do: :error

  defp build_headers(access_token) do
    %{
      "Authorization" => "#{access_token.token_type} #{access_token.access_token}"
    }
  end

  defp build_api_url(path) do
    "#{@api_url}#{path}"
  end
end

defmodule Music.SpotifyAuth do
  defmodule AccessTokenInfo do
    @enforce_keys [:access_token, :expires_in, :refresh_token, :token_type]
    defstruct [:access_token, :expires_in, :refresh_token, :token_type]

    def from_map(%{
      "access_token" => token,
      "expires_in" => expire,
      "refresh_token" => refresh_token,
      "token_type" => type
    }) do
      %AccessTokenInfo{
        access_token: token,
        expires_in: expire,
        refresh_token: refresh_token,
        token_type: type
      }
    end
  end

  @authorization_url "https://accounts.spotify.com/authorize?"
  @token_url "https://accounts.spotify.com/api/token"
  @scopes "user-read-private user-read-email user-top-read user-library-read user-read-recently-played"

  defp config_value(key) do
    config = Application.fetch_env!(:qrcode_router_service, :spotify_client)
    config[key]
  end

  defp client_id() do
    config_value(:client_id)
  end

  defp client_secret() do
    config_value(:client_secret)
  end

  defp redirect_uri() do
    config_value(:redirect_uri)
  end

  def get_authorize_url() do
    state = "tattoo-qrcode-spotify-session"
    scope = URI.encode(@scopes)
    "#{@authorization_url}client_id=#{client_id()}&scope=#{scope}&redirect_uri=#{redirect_uri()}&response_type=code&state=#{state}"
  end

  defp get_client_auth_password() do
    Base.encode64("#{client_id()}:#{client_secret()}")
  end

  def get_access_token(auth_code) do
    request_params = %{"code" => auth_code, "redirect_uri" => redirect_uri(), "grant_type" => "authorization_code"}
      |> URI.encode_query

    password = get_client_auth_password()
    headers = %{
      "Authorization" => "Basic #{password}",
      "Content-Type" => "application/x-www-form-urlencoded"
    }
    response = HTTPoison.post(@token_url, request_params, headers)
    response |> parse_response
  end

  defp parse_response({:ok, %HTTPoison.Response{body: response_data, status_code: 200}}) do
    response_data |> Jason.decode!
  end

  defp parse_response(_), do: :error
end
