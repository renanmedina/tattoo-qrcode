defmodule MusicChooser do
  import Logger

  alias Application.Entity.AvailableUrl

  @subkinds ["song", "playlist"]

  def pick_one_url! do
    url_kind = pick_url_sub_kind!()
    url_kind |> Logger.debug
    urls_for_kind = AvailableUrl.all_enabled_by(url_kind)
    length(urls_for_kind) |> Logger.debug
    case length(urls_for_kind) do
      0 -> raise Music.MusicUrlNotAvailableException
      _ ->
        case urls_for_kind |> ChooserAlgorithm.choose_one do
          picked_url when picked_url != nil -> picked_url.url
          _ -> raise Music.MusicUrlChooserException
        end
    end
  end

  defp pick_url_sub_kind!() do
    @subkinds |> ChooserAlgorithm.pick_random
  end
end
