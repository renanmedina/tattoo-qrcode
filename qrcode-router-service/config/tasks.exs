import Config

config :qrcode_router_service, QrcodeRouterService.TaskScheduler,
  jobs: [
    # Every Hour
    {"0 0 * * *", fn -> Music.Importing.import_new_played_songs() end }
  ]
