defmodule ServicePicker do
  @moduledoc """
  QrcodeRouterService keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias QrcodeRouterService.Repo
  alias ServicePicker.AvailableService
  alias ChooserAlgorithm

  import Ecto.Changeset

  def pick_service!(enabled_services \\ @enabled_services, algorithm \\ :random) do
    destination_service = ChooserAlgorithm.choose_one(enabled_services, algorithm)
    case destination_service do
      nil -> nil
      %{kind: k} when is_bitstring(k) ->
        update_service_statistics!(destination_service)
        destination_service
    end
  end

  defp update_service_statistics!(service) do
    service
      |> change(%{
        redirects_count: service.redirects_count + 1,
        last_redirected_at: DateTime.utc_now() |> (&(DateTime.truncate(&1, :second))).()
      })
      |> Repo.update
  end
end
