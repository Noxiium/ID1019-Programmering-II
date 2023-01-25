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
  ##          2       7
  ##       1    3   6    20
  ##

  def create_tree() do :nil end

  def add(:nil, key, value) do {:node, key, value, :nil, :nil} end
  def add({:node, key, _, left, right}, key, value) do
    {:node, key, value, left, right}
  end

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
  def remove({:node, key, value, left, right}, key) do

  end



end
