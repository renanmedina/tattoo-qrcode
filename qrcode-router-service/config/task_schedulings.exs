import Config

config :quantum, :qrcode_router_service, cron: [
  # every hour
  "0 0 * * *": fn -> Music.Importing.import_new_played_songs() end
]
