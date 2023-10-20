defmodule QrcodeRouterService.Repo.Migrations.RenameAvailableMedias do
  use Ecto.Migration

  def change do
    rename table(:available_medias), to: table(:available_urls)
  end
end
