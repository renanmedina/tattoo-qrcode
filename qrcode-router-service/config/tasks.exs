import Config

config :qrcode_router_service, QrcodeRouterService.TaskScheduler,
  jobs: [
    # Every Hour
    {"0 0 * * *", {Music.Importing, :import_new_played_songs, []}}
  ]
