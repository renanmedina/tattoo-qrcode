defmodule QrcodeRouting.AvailableService do
  @derive Jason.Encoder
  @enforce_keys [:kind, :url]
  defstruct [:kind, :url, redirects_count: 0]
end

defmodule QrcodeRouting do
  @moduledoc """
  QrcodeRouterService keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias QrcodeRouting.AvailableService

  @enabled_services [
    %AvailableService{
      kind: "music_and_playlists",
      url: "https://open.spotify.com",
      redirects_count: 0
    },
    %AvailableService{
      kind: "websites",
      url: "https://gohorse.com.br/extreme-go-horse-xgh/",
      redirects_count:  0
    },
    %AvailableService{
      kind: "status",
      url: "https://qrcode-tattoo-services.silvamedina.com.br/status",
      redirects_count: 0
    },
    %AvailableService{
      kind: "jokes",
      url: "https://qrcode-tattoo-services.silvamedina.com.br/jokes",
      redirects_count: 0
    },
    %AvailableService{
      kind: "quotes",
      url: "https://qrcode-tattoo-services.silvamedina.com.br/quotes",
      redirects_count: 0
    },
    %AvailableService{
      kind: "memes",
      url: "https://qrcode-tattoo-services.silvamedina.com.br/memes",
      redirects_count: 0
    }
  ]

  def route_service!() do
    enabled_services = get_enabled_services()
    destination_service = select_service(enabled_services)
    update_service_statistics!(destination_service)
    destination_service
  end

  defp select_service(enabled_services) do
    case [is_round_robin_enabled?, round_robin_algorithm] do
      [is_enabled, algorithm] when is_enabled == true -> round_robin_service(enabled_services, algorithm)
      [is_enabled, _] when is_enabled == false -> randomize_service(enabled_services)
    end
  end

  defp update_service_statistics!(service) do
  end

  def get_enabled_services() do
    @enabled_services
  end

  def is_round_robin_enabled?() do
    false
  end

  defp round_robin_algorithm() do
    :even_balance_algorithm
  end

  defp round_robin_service(services_list, algorithm) do
    case algorithm do
      :even_balance_algorithm ->
        services_list |> List.first(services_list)
      _ ->
        services_list |> List.first(services_list)
    end
  end

  defp randomize_service(services_list) do
    rand_index = Enum.random(0..length(services_list)-1)
    Enum.at(services_list, rand_index)
  end
end
