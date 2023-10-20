defmodule QrcodeRoutingTest do
  use ExUnit.Case

  describe "When using random algorithm" do
    test "returns randomly service from enabled list" do
      available_services = QrcodeRouting.get_enabled_services
      destination1 = QrcodeRouting.pick_service!(available_services)
      destination2 = QrcodeRouting.pick_service!(available_services)
      assert destination1 in available_services
      assert destination2 in available_services
      refute destination1 == destination2
    end
  end
end
