defmodule EnvTree do

  ## Each node is represented as a following tuple:
  ## {:node, key, value, left, right} where left and right
  ## are the nodes branches. If the node has no left branch
  ## the value left is equal to the atom :nil. Same goes for
  ## the right branch. If both left and right are :nil the
  ## node is an leaf.
  ##
  ## To remove one node we first have to find it using the same
  ## logic as the lookup method. Once found we remove it and replace
  ## it with leftmost key-value pair in the right
  ## branch (or the rightmost in the left branch).
  ##
  ##              4
  ##          1       20
  ##      nil    2   6    10
  ##

  def new() do :nil end

  def add(:nil, key, value) do {:node, key, value, :nil, :nil} end
  def add({:node, key, _, left, right}, key, value) do {:node, key, value, left, right} end
  def add({:node, k, v, left, right}, key, value) do
    if key < k do #left
      {:node, k, v, add(left, key, value), right}
    else
      {:node, k, v, left, add(right, key, value),}
    end
  end

  def lookup(:nil, _) do :nil end
  def lookup({:node, key, value, _, _}, key) do {key, value} end
  def lookup({:node, k, _, left, right}, key) do
    if key < k do #left
      lookup(left,key)
    else
      lookup(right,key)
    end
  end

  def remove(:nil, _) do :nil end
  def remove({:node, key, _, :nil, :nil}, key) do :nil end
  def remove({:node, key, _, left, :nil}, key) do left end
  def remove({:node, key, _, :nil, right}, key) do right end
  def remove({:node, key, _, left, right}, key) do
    {key, value, right} = find_leftmost(right)
    {:node, key, value, left, right}
  end
  def remove({:node, k, v, left, right}, key) do
    if key < k do #left
      {:node, k, v, remove(left, key), right}
    else
      {:node, k, v, left, remove(right, key),}
    end
  end

  def find_leftmost({:node, key, value, :nil, right}) do {key, value, right} end
  def find_leftmost({:node, k, v, left, right}) do
    {key, value, left} = find_leftmost(left)
    {key, value, {:node, k, v, left, right}}
  end

  def print {:node, k, _, :nil, :nil} do "#{k} end" end
  def print {:node, k, _, left, :nil} do "#{k} left[#{print(left)}]"
  end
  def print {:node, k, _, :nil, right} do "#{k} right[#{print(right)}]"
  end
  def print {:node, k, _, left, right} do "#{k} left[#{print(left)}]right[#{print(right)}]"
  end
end
