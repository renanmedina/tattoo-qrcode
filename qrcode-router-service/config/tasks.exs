import Config

config :qrcode_router_service, QrcodeRouterService.TaskScheduler,
  jobs: [
    # Every 30 minutes
    {"*/30 * * * *", {Music.Importing, :import_new_played_songs, []}},
    # Every 35 minutes
    {"*/35 * * * *", {Music.Importing, :import_new_playlists, []}}
  ]
