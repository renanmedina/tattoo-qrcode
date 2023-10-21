defmodule Music.Importing do
  alias Application.Entity.SettingItem
  alias Music.SpotifyClient
  alias Music.SpotifyAuth.AccessTokenInfo

  def import_new_played_songs() do
    token_data = SettingItem.get_spotify_token()
    access_token = token_data |> AccessTokenInfo.from_map
    results = SpotifyClient.get_recent_played_songs(access_token)
    results |> List.first
  end
end
