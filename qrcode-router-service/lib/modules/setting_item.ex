defmodule Application.Entity.SettingItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias QrcodeRouterService.Repo
  alias Application.Entity.SettingItem

  @spotify_token_key "spotify_access_token"

  @derive {Jason.Encoder, only: [:setting_key, :setting_value]}
  @enforce_keys [:setting_key, :setting_value]
  schema "settings" do
    field :setting_key, :string
    field :setting_value, :string
    timestamps()
  end

  def get_all() do
    Repo.all(SettingItem)
  end

  def get_by_setting_key(key) do
    Repo.get_by(SettingItem, setting_key: key)
  end

  def put_value(setting_key, setting_value) do
    case SettingItem.get_by_setting_key(setting_key) do
      setting when setting != nil ->
        setting
          |> change(%{setting_value: setting_value})
          |> Repo.update
      _ ->
        Repo.insert(%SettingItem{setting_key: setting_key, setting_value: setting_value})
    end
  end

  def save_spotify_token(token_data) do
    token_value = token_data |> Jason.encode!
    put_value(@spotify_token_key, token_value)
  end

  def get_spotify_token() do
    config = get_by_setting_key(@spotify_token_key)
    config.setting_value |> Jason.decode!
  end
end
