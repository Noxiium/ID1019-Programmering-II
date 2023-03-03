defmodule Shunt do

  def check_find(train1, train2) do
    moves = find(train1,train2)
    state = Shunt.get_last_state(Moves.sequence(moves, {train1, [], []}))
    state == {train2, [], []}
  end
  def get_last_state([last_state]), do: last_state
  def get_last_state([h | t]) do
    get_last_state(t)
  end

  def find([], []), do: []

  def find(train1, [h2 | t2]) do
    {left_split, right_split} = Train.split(train1, h2)
    right_length = Train.count(right_split)
    left_length = Train.count(left_split)
    new_train = Train.append(right_split,left_split)
    if left_length>0 do
      [{:one, (right_length+1)},{:two, left_length},{:one, -(right_length+1)},{:two, -left_length} | find(new_train, t2)]
    else
       find(new_train, t2)
    end
  end

end
