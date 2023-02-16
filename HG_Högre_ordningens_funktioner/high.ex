defmodule High do

  def double_five_animal(([]), _), do: []

  def double_five_animal([h | t], operation) do
    case operation do
      :double -> [h * 2 | double_five_animal(t, operation)]
      :five -> [h + 5 | double_five_animal(t, operation)]
      :animal ->
      if h == :dog do
        [:fido | double_five_animal(t, operation)]
        else
          [h | double_five_animal(t, operation)]
      end
    end
  end



  def apply_to_all([], _),  do: []
  def apply_to_all([h | t], function) do
    [function.(h) | apply_to_all(t, function)]
  end



  def sum([]), do: 0
  def sum([h|t]) do
    h + sum(t)
  end


  def fold_right([], acc, _), do: acc
  def fold_right([h | t], acc, f) do
    f.(h, fold_right(t, acc, f))
  end

  def fold_left([], acc, _), do: acc
  def fold_left([h | t], acc, f) do
    fold_left(t, f.(h, acc), f)
  end

  def odd(list) do
    filter(list, (fn(x) -> rem(x,2) == 1 end))
  end

  def even(list) do
    filter(list, (fn(x) -> rem(x,2) == 0 end))
  end

  def higher_then(list, n) do
    filter(list, (fn(x) -> x>n end))
  end

  def lower_then(list, n) do
    filter(list, (fn(x) -> x<n end))
  end

  def filter([], _), do: []
  def filter([h | t], f) do
    if f.(h) do
      [h | filter(t, f)]
    else
      filter(t, f)
    end
  end



end
