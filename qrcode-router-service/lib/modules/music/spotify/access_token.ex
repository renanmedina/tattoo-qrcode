defmodule Music.SpotifyAuth.AccessToken do
  alias Music.SpotifyAuth.AccessToken

  @enforce_keys [:access_token, :expires_in, :refresh_token, :token_type]
  defstruct [:access_token, :expires_in, :refresh_token, :token_type]

  def from_map(%{
    "access_token" => token,
    "expires_in" => expire,
    "refresh_token" => refresh_token,
    "token_type" => type,
    "scope" => scope
  }) do
    %AccessToken{
      access_token: token,
      expires_in: expire,
      refresh_token: refresh_token,
      token_type: type
    }
  end
end
