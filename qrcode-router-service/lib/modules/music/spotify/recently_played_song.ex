defmodule Music.SpotifyClient.RecentlyPlayedSong do
  alias Music.SpotifyClient.RecentlyPlayedSong
  alias Music.SpotifyClient.Artist

  @enforce_keys [:url, :album_url, :explicit]
  defstruct [:url, :album_url, :explicit, artists: []]

  def from_map(map) do
    track_map = map["track"]
    %RecentlyPlayedSong{
      url: track_map["external_urls"]["spotify"],
      album_url: track_map["album"]["external_urls"]["spotify"],
      explicit: track_map["explicit"],
      artists: track_map["artists"] |> Enum.map(&(Artist.from_map(&1)))
    }
  end
end
