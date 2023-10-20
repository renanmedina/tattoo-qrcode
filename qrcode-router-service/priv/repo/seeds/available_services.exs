alias QrcodeRouterService.Repo

services_seeds = [
  %ServicePicker.Entity.AvailableService{
    kind: "music_and_playlists",
    name: "Música & Playlists",
    url: "https://tattoo-qrcode.renanmedina.online/music_and_playlists",
    enabled: true,
    is_internal: true,
    redirects_count: 0
  },
  %ServicePicker.Entity.AvailableService{
    kind: "websites",
    name: "Websites",
    url: "https://tattoo-qrcode.renanmedina.online/websites",
    enabled: true,
    is_internal: true,
    redirects_count:  0
  },
  %ServicePicker.Entity.AvailableService{
    kind: "memes",
    name: "Memes",
    url: "https://tattoo-qrcode.renanmedina.online/memes",
    enabled: true,
    is_internal: true,
    redirects_count: 0
  },
  %ServicePicker.Entity.AvailableService{
    kind: "personal_facts",
    name: "Curiosidades Pessoais",
    url: "https://tattoo-qrcode.renanmedina.online/personal_facts",
    enabled: true,
    is_internal: true,
    redirects_count: 0
  }
]

insert_data = fn data_item -> Repo.insert!(data_item) end
services_seeds |> Enum.map(&(insert_data.(&1)))
