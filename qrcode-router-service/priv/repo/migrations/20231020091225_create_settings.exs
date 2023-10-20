defmodule QrcodeRouterService.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :setting_key, :string
      add :setting_value, :string
      timestamps()
    end

    create unique_index(:settings, [:setting_key])
  end
end
