defmodule QrcodeRouterService.Repo.Migrations.AddServiceKindColumnToAvailableUrls do
  use Ecto.Migration

  def change do
    alter table(:available_urls) do
      add :service_kind, :string
      add :available_service_id, references(:available_services)
    end

    create index(:available_urls, [:available_service_id])
  end
end
