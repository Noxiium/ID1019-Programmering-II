defmodule Train do

  def count([]), do: 0;
  def count([_|t]), do: 1 + count(t)

  @doc """
   returns the train containing
   the first n wagons of train
  """
  def take(_, 0), do: []
  def take([h | t], n) do
    if n > 0 do
      [h | take(t, n-1)]
    end
  end
  @doc """
   returns the train without
   its first n wagon
  """
  def drop(train, 0), do: train
  def drop([_ | t], n) do
      drop(t, n-1)
  end

  @doc """
   returns the train that is the
   combinations of the two trains
  """
  def append([], train2), do: train2
  def append([h | t], train2) do
    [h | append(t, train2)]
  end

  @doc """
   tests whether y is a wagon of train
  """
  def member([], _), do: false
  def member([y | _], y), do: true
  def member([_ | t], y), do: member(t,y)

  @doc """
   returns the first position (1 indexed) of y in the
   train train. You can assume that y is a wagon in train
  """
  def position(train, y), do: position(train, y, 1)
  def position([], _, _), do: {:error, :indexOutOfBounds}
  def position([y | _], y, n), do: n
  def position([_ | t], y, n), do: position(t, y, n+1)

  @doc """
   return a tuple with two trains, all the wagons before
   y and all wagons after y (i.e. y is not part in either).
  """
  def split(train, y) do
    n = position(train, y)
    {take(train, n-1), drop(train, n)}
  end

  @doc """
   returns the tuple {k, remain, take} where
   remain and take are the wagons of train
   and k are the numbers of wagons remaining
   to have n wagons in the taken part
  """
  def main([], n), do: {n, [], []}
  def main([last_wagon], n), do: {n-1,[], [last_wagon]}
  def main([h | t], n) do
    {k, remain, take} = main(t, n)
    if k==0 do
      {k, [h|remain], take}
    else
      {k-1, remain, [h | take]}
    end
  end

end
