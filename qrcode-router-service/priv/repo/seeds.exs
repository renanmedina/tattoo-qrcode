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

Code.require_file("./priv/repo/seeds/available_services.exs")
Code.require_file("./priv/repo/seeds/available_medias.exs")
Code.require_file("./priv/repo/seeds/default_settings.exs")
