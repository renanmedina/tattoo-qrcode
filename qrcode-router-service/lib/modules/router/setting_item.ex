defmodule ServicePicker.Entity.SettingItem do
  use Ecto.Schema
  alias QrcodeRouterService.Repo

  @derive {Jason.Encoder, only: [:setting_key, :setting_value]}
  @enforce_keys [:setting_key, :setting_value]
  schema "settings" do
    field :setting_key, :string
    field :setting_value, :string

    timestamps()
  end

  def get_all() do
    Repo.all(ServicePicker.Entity.SettingItem)
  end
end
