alias QrcodeRouterService.Repo

services_seeds = []
insert_data = fn data_item -> Repo.insert!(data_item) end
services_seeds |> Enum.map(&(insert_data.(&1)))
