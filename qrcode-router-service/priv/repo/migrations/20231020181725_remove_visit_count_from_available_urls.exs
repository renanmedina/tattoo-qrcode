defmodule QrcodeRouterService.Repo.Migrations.RemoveVisitsCountFromAvailableUrls do
  use Ecto.Migration

  def change do
    alter table(:available_urls) do
      remove :visits_count
    end
  end
end
