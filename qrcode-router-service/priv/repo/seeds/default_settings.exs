alias QrcodeRouterService.Repo

settings_seed = [
  %Application.Entity.SettingItem{
    setting_key: "service_picker_algorithm",
    setting_value: "random"
  }
]

insert_data = fn data_item -> Repo.insert!(data_item) end
settings_seed |> Enum.map(&(insert_data.(&1)))
