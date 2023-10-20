defmodule ChooserAlgorithmTest do
  use ExUnit.Case

  setup_all do
    %{
      available_services: [
        %ServicePicker.Entity.AvailableService{
          id: 1,
          kind: "music_and_playlists",
          name: "Música & Playlists",
          url: "https://tattoo-qrcode.renanmedina.online/music_and_playlists",
          enabled: true,
          is_internal: true,
          redirects_count: 0
        },
        %ServicePicker.Entity.AvailableService{
          id: 2,
          kind: "websites",
          name: "Websites",
          url: "https://tattoo-qrcode.renanmedina.online/websites",
          enabled: true,
          is_internal: true,
          redirects_count:  0
        },
        %ServicePicker.Entity.AvailableService{
          id: 3,
          kind: "memes",
          name: "Memes",
          url: "https://tattoo-qrcode.renanmedina.online/memes",
          enabled: true,
          is_internal: true,
          redirects_count: 0
        },
        %ServicePicker.Entity.AvailableService{
          id: 4,
          kind: "personal_facts",
          name: "Curiosidades Pessoais",
          url: "https://tattoo-qrcode.renanmedina.online/personal_facts",
          enabled: true,
          is_internal: true,
          redirects_count: 0
        }
      ]
    }
  end

  describe "When using random algorithm" do
    test "returns randomly service from enabled list", state do
      available_services = state[:available_services]
      destination1 = available_services |> ChooserAlgorithm.pick_random
      destination2 = available_services |> ChooserAlgorithm.pick_random
      assert destination1 in available_services
      assert destination2 in available_services
      refute destination1 == destination2
    end
  end
end
