defmodule Music.Importing do
  require Logger

  alias Application.Entity.SettingItem
  alias Application.Entity.AvailableUrl
  alias Music.SpotifyClient
  alias Music.SpotifyAuth
  alias Music.SpotifyAuth.AccessTokenInfo

  def import_new_played_songs() do
    {access_token, refresh_token} = get_saved_token()

    try do
      api_results = SpotifyClient.get_recent_played_songs(access_token)
      # map results song urls from api and save records in database that are missing
      save_missing_urls(api_results, "song")
    rescue
      Music.SpotifyClient.TokenExpiredException ->
        refresh_spotify_token(refresh_token)
        import_new_played_songs()
    end
  end

  def import_new_playlists() do
    {access_token, refresh_token} = get_saved_token()

    try do
      api_results = SpotifyClient.get_playlists(access_token)
      # map results playlists urls from api and save records in database that are missing
      save_missing_urls(api_results, "playlist")
    rescue
      Music.SpotifyClient.TokenExpiredException ->
        refresh_spotify_token(refresh_token)
        import_new_playlists()
    end
  end

  defp save_missing_urls(results, kind) do
    results
      |> Enum.map(&(&1.url))
      |> Enum.map(&(AvailableUrl.create_if_missing_by(%{url: &1, kind: kind, service_kind: "music"})))
      |> Enum.reject(&(is_nil(&1)))
  end

  defp refresh_spotify_token(refresh_token) do
    new_access_token = SpotifyAuth.refresh_token(refresh_token)
    debug_log("Refreshed token for spotify API")
    SettingItem.save_spotify_token(new_access_token)
  end

  defp get_saved_token() do
    token_data = SettingItem.get_spotify_token()
    saved_token = token_data |> AccessTokenInfo.from_map
    debug_log("importing recent played songs from spotify with access_token #{saved_token.access_token}")
    {saved_token.access_token, saved_token.refresh_token}
  end

  defp debug_log(message) do
    "qrcode.router.service.crontask.music.importer: #{message}" |> Logger.debug
  end
end
