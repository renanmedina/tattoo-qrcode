defmodule QrcodeRouting.AvailableService do
  use Ecto.Schema
  alias QrcodeRouterService.Repo

  schema "available_services" do
    field :kind, :string
    field :name, :string
    field :url, :string
    field :redirects_count, :integer
    field :enabled, :boolean
    field :is_internal, :boolean
    field :last_redirected_at, :naive_datetime

    timestamps()
  end

  @derive Jason.Encoder
  @enforce_keys [:kind, :url]
  # defstruct [:kind, :url, redirects_count: 0]
end

defmodule QrcodeRouting do
  @moduledoc """
  QrcodeRouterService keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias QrcodeRouterService.Repo
  alias QrcodeRouting.AvailableService
  alias QrcodeRouting.ChooserAlgorithm

  def pick_service!(enabled_services \\ @enabled_services, algorithm \\ :random) do
    destination_service = ChooserAlgorithm.choose_one(enabled_services, algorithm)
    update_service_statistics!(destination_service)
    destination_service
  end

  defp update_service_statistics!(service) do
  end

  def get_enabled_services() do
    Repo.all(AvailableService)
  end
end
