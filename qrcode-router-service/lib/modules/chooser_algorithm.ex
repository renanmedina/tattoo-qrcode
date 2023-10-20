defmodule QrcodeRouting.ChooserAlgorithm do

  @algorithms [:random, :even_balance_round_robin]

  def pick_random(list) do
    rand_index = Enum.random(0..length(list) - 1)
    Enum.at(list, rand_index)
  end

  def choose_one(list, algorithm \\ :random) when algorithm == :random, do: pick_random(list)
end
