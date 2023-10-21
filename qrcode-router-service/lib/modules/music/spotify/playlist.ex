defmodule Music.SpotifyClient.Playlist do
  alias Music.SpotifyClient.Playlist

  @enforce_keys [:id, :url, :name, :is_public]
  defstruct [:id, :url, :name, :is_public]

  def from_map(map) do
    %Playlist{
      id: map["id"],
      url: map["external_urls"]["spotify"],
      name: map["name"],
      is_public: map["public"]
    }
  end
end
