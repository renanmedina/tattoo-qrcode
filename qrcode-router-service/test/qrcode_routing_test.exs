defmodule QrcodeRoutingTest do
  use ExUnit.Case

  describe "When round robin is disabled" do
    test "returns false" do
      assert QrcodeRouting.is_round_robin_enabled? == false
    end

    test "returns randomly service from enabled list" do
      urls_extractor = fn service -> service.url end
      available_services = QrcodeRouting.get_enabled_services |> Enum.map(urls_extractor)
      destination1 = QrcodeRouting.route_service!
      destination2 = QrcodeRouting.route_service!
      assert destination1.url in available_services
      assert destination2.url in available_services
      refute destination1 == destination2
    end
  end
end
