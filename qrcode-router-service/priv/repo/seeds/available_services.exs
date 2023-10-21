alias QrcodeRouterService.Repo

services_seeds = [
  %ServicePicker.Entity.AvailableService{
    kind: "music_and_playlists",
    name: "Música & Playlists",
    url: "http://localhost:4000/music_and_playlists",
    enabled: true,
    is_internal: true,
    redirects_count: 0
  },
  %ServicePicker.Entity.AvailableService{
    kind: "websites",
    name: "Websites",
    url: "http://localhost:4000/websites",
    enabled: true,
    is_internal: true,
    redirects_count:  0
  },
  %ServicePicker.Entity.AvailableService{
    kind: "memes",
    name: "Memes",
    url: "http://localhost:4000/memes",
    enabled: true,
    is_internal: true,
    redirects_count: 0
  },
  %ServicePicker.Entity.AvailableService{
    kind: "personal_facts",
    name: "Curiosidades Pessoais",
    url: "http://localhost:4000/personal_facts",
    enabled: true,
    is_internal: true,
    redirects_count: 0
  }
]

insert_data = fn data_item -> Repo.insert!(data_item) end
services_seeds |> Enum.map(&(insert_data.(&1)))
