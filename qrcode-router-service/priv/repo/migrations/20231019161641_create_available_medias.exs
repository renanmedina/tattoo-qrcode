defmodule QrcodeRouterService.Repo.Migrations.CreateAvailableMedias do
  use Ecto.Migration

  def change do
    create table(:available_medias) do
      add :kind, :string
      add :url, :string
      add :visits_count, :integer
      add :enabled, :boolean
      add :last_visited_at, :timestamp
      timestamps()
    end

    create unique_index(:available_medias, [:kind, :url])
  end
end
