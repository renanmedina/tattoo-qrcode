defmodule Application.Entity.AvailableUrl do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias QrcodeRouterService.Repo
  alias Application.Entity.AvailableUrl

  @ensure_keys [:kind, :service_kind, :url]
  schema "available_urls" do
    field :kind, :string
    field :service_kind, :string
    field :url, :string
    field :enabled, :boolean
    timestamps()
  end

  def all_enabled_by(kind) do
    from(u in AvailableUrl, where: u.kind == ^kind and u.enabled == true)
      |> Repo.all()
  end

  def all_enabled_by(service_kind, kind) do
    from(
        u in AvailableUrl,
        where: u.service_kind == ^service_kind and u.kind == ^kind and u.enabled == true
      )
      |> Repo.all
  end

  def get_by(kind, url) do
    Repo.get_by(AvailableUrl, %{url: url, kind: kind})
  end

  def create_if_missing_by(%{url: url, kind: kind, service_kind: service_kind}) do
    case get_by(kind, url) do
      url_item when url_item == nil -> Repo.insert(%AvailableUrl{kind: kind, url: url, service_kind: service_kind})
      _ -> nil # ignore when url already exists for kind
    end
  end

  def save_by(%{url: url, kind: kind, service_kind: service_kind}) do
    case get_by(kind, url) do
      url_item when url_item != nil ->
        url_item
          |> change(%{url: url, kind: kind, service_kind: service_kind})
          |> Repo.update
      _ ->
        Repo.insert(%AvailableUrl{kind: kind, url: url, service_kind: service_kind})
    end
  end
end
