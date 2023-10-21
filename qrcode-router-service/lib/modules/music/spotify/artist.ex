defmodule Music.SpotifyClient.Artist do
  alias Music.SpotifyClient.Artist

  @enforce_keys [:id, :name, :followers]
  defstruct [:id, :name, :followers]

  def from_map(map) do
    %Artist{
      id: map["id"],
      name: map["name"],
      followers: map["followers"],
    }
  end
end
