defmodule ServicePicker.Entity.AvailableService do
  use Ecto.Schema
  import Ecto.Query
  alias QrcodeRouterService.Repo

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

  def get_enableds() do
    Repo.all(from(s in ServicePicker.Entity.AvailableService, where: s.enabled == true))
  end
end
