defmodule QrcodeRouterService.Repo.Migrations.CreateAvailableServices do
  use Ecto.Migration

  def change do
    create table(:available_services) do
      add :kind, :string
      add :name, :string
      add :url, :string
      add :redirects_count, :integer, default: 0
      add :enabled, :boolean
      add :is_internal, :boolean
      add :last_redirected_at, :timestamp

      timestamps()
    end

    create unique_index(:available_services, [:kind, :url])
  end
end
