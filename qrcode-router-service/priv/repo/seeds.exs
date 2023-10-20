# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     QrcodeRouterService.Repo.insert!(%QrcodeRouterService.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

default_services = [
  %QrcodeRouting.AvailableService{
    kind: "music_and_playlists",
    name: "Música & Playlists",
    url: "https://tattoo-qrcode.renanmedina.online/music_and_playlists",
    enabled: true,
    is_internal: true,
    redirects_count: 0
  },
  %QrcodeRouting.AvailableService{
    kind: "websites",
    name: "Websites",
    url: "https://tattoo-qrcode.renanmedina.online/websites",
    enabled: true,
    is_internal: true,
    redirects_count:  0
  },
  %QrcodeRouting.AvailableService{
    kind: "memes",
    name: "Memes",
    url: "https://tattoo-qrcode.renanmedina.online/memes",
    enabled: true,
    is_internal: true,
    redirects_count: 0
  },
  %QrcodeRouting.AvailableService{
    kind: "personal_facts",
    name: "Curiosidades Pessoais",
    url: "https://tattoo-qrcode.renanmedina.online/personal_facts",
    enabled: true,
    is_internal: true,
    redirects_count: 0
  }
]

insert_data = fn data_item -> QrcodeRouterService.Repo.insert!(data_item) end
default_services |> Enum.map(&(insert_data.(&1)))
