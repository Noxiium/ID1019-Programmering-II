defmodule Moves do

  def single({track, n}, {main, track1, track2}) do
    if n>0 do
      {k, left_on_main, moved_carts } = Train.main(main, n)
      case track do
        :one ->
          {left_on_main, Train.append(moved_carts, track1), track2}
        :two -> {left_on_main, track1, Train.append(moved_carts, track2)}
      end
    else
      n = n*-1
      case track do
        :one ->
          left_on_track1 = Train.drop(track1, n)
          moved_to_main = Train.take(track1, n)
          {Train.append(main, moved_to_main), left_on_track1, track2}
        :two ->
          left_on_track2 = Train.drop(track2, n)
          moved_to_main = Train.take(track2, n)
          {Train.append(main, moved_to_main), track1, left_on_track2}
      end
    end
  end

  def sequence([], state), do: [state]
  def sequence([h | t], state) do
    [state] ++ sequence(t, single(h, state))
  end


end
