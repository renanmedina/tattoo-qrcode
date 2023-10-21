defmodule QrcodeRouterService.Repo.Migrations.ChangeEnabledColumnFromAvailableUrls do
  use Ecto.Migration

  def change do
    alter table(:available_urls) do
      modify :enabled, :boolean, null: true, default: true
    end
  end
end
