defmodule Music.SpotifyClient do
  alias Music.SpotifyAuth.AccessToken
  alias Music.SpotifyClient.{RecentlyPlayedSong, Playlist}

  @api_url "https://api.spotify.com/v1/me"

  def get_recent_played_songs(access_token, limit \\ 20) do
    response = make_request("/player/recently-played", %{limit: limit}, access_token)
    response |> parse_response |> pluck_items |> Enum.map(&(RecentlyPlayedSong.from_map(&1)))
  end

  def get_playlists(access_token, limit \\ 20) do
    response = make_request("/playlists", %{limit: limit}, access_token)
    response |> parse_response |> pluck_items |> Enum.map(&(Playlist.from_map(&1)))
  end

  defp pluck_items(response), do: response["items"]

  defp make_request(path, params, access_token), do: HTTPoison.get("#{build_api_url(path)}?#{URI.encode_query(params)}", build_headers(access_token))
  defp make_request(path, access_token), do: HTTPoison.get(build_api_url(path), build_headers(access_token))

  defp parse_response({:ok, %HTTPoison.Response{body: body_data, status_code: 200}}), do: body_data |> Jason.decode!
  # handle expired token
  defp parse_response({:ok, %HTTPoison.Response{status_code: 401, body: body_data}}) do
    data = body_data |> Jason.decode!
    raise Music.SpotifyClient.TokenExpiredException, message: data["error"]["message"]
  end

  defp build_headers(access_token) do
    %{
      "Authorization" => "Bearer #{access_token}"
    }
  end

  defp build_api_url(path) do
    "#{@api_url}#{path}"
  end
end

defmodule Music.SpotifyAuth do
  alias Music.SpotifyAuth.AccessToken

  @authorization_url "https://accounts.spotify.com/authorize?"
  @token_url "https://accounts.spotify.com/api/token"
  @scopes "user-read-private user-read-email user-follow-read user-top-read playlist-read-private user-library-read user-read-recently-played"

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
    response = HTTPoison.post(@token_url, request_params, build_headers())
    response |> parse_response
  end

  def refresh_token(token) do
    request_params = %{"refresh_token" => token, "grant_type" => "refresh_token"} |> URI.encode_query
    response = HTTPoison.post(@token_url, request_params, build_headers())
    new_token_response = response |> parse_response
    ## keep refresh_token since spotify does not provide a new one
    Map.put(new_token_response, "refresh_token", token)
  end

  defp build_headers() do
    password = get_client_auth_password()
    %{
      "Authorization" => "Basic #{password}",
      "Content-Type" => "application/x-www-form-urlencoded"
    }
  end

  defp parse_response({:ok, %HTTPoison.Response{body: response_data, status_code: 200}}) do
    response_data |> Jason.decode!
  end

  # defp parse_response(_), do: :error
end
