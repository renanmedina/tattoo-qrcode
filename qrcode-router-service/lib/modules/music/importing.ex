defmodule Music.Importing do
  require Logger

  alias Application.Entity.SettingItem
  alias Application.Entity.AvailableUrl
  alias Music.SpotifyClient
  alias Music.SpotifyAuth.AccessTokenInfo

  def import_new_played_songs() do
    token_data = SettingItem.get_spotify_token()
    access_token = token_data |> AccessTokenInfo.from_map
    access_token.access_token |> debug_log
    api_results = SpotifyClient.get_recent_played_songs(access_token)
    # map results song urls from api and save records in database that are missing
    save_missing_urls(api_results, "song")
  end

  def import_new_playlists() do
    token_data = SettingItem.get_spotify_token()
    access_token = token_data |> AccessTokenInfo.from_map
    access_token.access_token |> debug_log
    api_results = SpotifyClient.get_playlists(access_token)
    # map results playlists urls from api and save records in database that are missing
    save_missing_urls(api_results, "playlists")
  end

  defp save_missing_urls(results, kind) do
    results
      |> Enum.map(&(&1.url))
      |> Enum.map(&(AvailableUrl.create_if_missing_by(%{url: &1, kind: kind, service_kind: "music"})))
  end

  defp debug_log(acess_token) do
    "qrcode.router.service.crontask.music.importer: importing recent played songs from spotify with access_token"
      |> Logger.debug
  end
end
