defmodule Queue do

  def new(), do: {:queue, [], []}

  def add({:queue, front, back}, element) do
    {:queue, front, [element|back]}
  end

  def remove({:queue, [], []}) do [] end
  def remove({:queue, [], back}) do
    remove({:queue, reverse(back), []})
  end
  def remove ({:queue, [element|rest], back}) do
    {:queue, rest, back}
  end

  def reverse(list) do reverse(list, []) end
  def reverse([], rev) do rev end
  def reverse([h|t], rev) do reverse(t, [h|rev]) end

end
