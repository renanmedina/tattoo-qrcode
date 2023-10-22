defmodule ServicePicker.Entity.AvailableService do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias QrcodeRouterService.Repo
  alias ServicePicker.Entity.AvailableService

  @derive {Jason.Encoder, only: [:kind, :url, :redirects_count, :last_redirected_at]}
  @enforce_keys [:kind, :url]
  schema "available_services" do
    field :kind, :string
    field :name, :string
    field :url, :string
    field :redirects_count, :integer
    field :enabled, :boolean
    field :is_internal, :boolean
    field :last_redirected_at, :utc_datetime
    timestamps()
  end

  @doc false
  def changeset(service, attrs) do
    service
      |> cast(attrs, [:kind, :url, :name, :enabled])
      |> validate_required([:kind, :url, :name])
  end

  def get_by(kind), do: Repo.get_by(AvailableService, %{kind: kind})
  def get_all(), do: Repo.all(AvailableService)
  def get_enableds(), do: Repo.all(from(s in AvailableService, where: s.enabled == true))
  def get_disableds(), do: Repo.all(from(s in AvailableService, where: s.enabled == false))

  def create(kind, url, name, nil), do: create(kind, url, name, true)
  def create(kind, url, name, is_enabled \\ true) do
    create_dto = %{
      "kind" => kind,
      "name" => name,
      "url" => url,
      "enabled" => is_enabled
    }

    %AvailableService{kind: kind, url: url}
      |> AvailableService.changeset(create_dto)
      |> Repo.insert()
  end

  def toggle_active(service) do
    service
      |> change(%{enabled: !service.enabled})
      |> Repo.update
  end
end
