defmodule Music.SpotifyClient.RecentlyPlayedSong do
  alias Music.SpotifyClient.RecentlyPlayedSong

  @enforce_keys [:track]
  defstruct [:track]

  def from_map(map) do
    %RecentlyPlayedSong{
      track: map["track"]
    }
  end
end
