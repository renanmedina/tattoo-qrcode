defmodule QrcodeRouterService.Repo.Migrations.ChangeSettingValueFromSettings do
  use Ecto.Migration

  def change do
    alter table(:settings) do
      modify :setting_value, :text, null: true
    end
  end
end
