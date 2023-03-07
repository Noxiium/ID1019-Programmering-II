defmodule Huffman do

  ## NODE = {:node, {:data, char, codepoint freq}, left_child, right_child}

  def sample_text() do
    'ffffffffffffffffffffffffffffffffffeeeeeeeeeeeeeeeeeeeedddddddddddddccccccccccccbbbbbbbbbaaaaaa'
  end

  def tree() do
    frequency_list = get_frequency_list_in_order(sample_text)
    make_tree(frequency_list)
  end


  def make_tree([{root, _freq}]), do: 0

  def make_tree(list) do
    IO.inspect(list)
    [{left_node, left_node_freq} | list] = list
    [{right_node, right_node_freq} | list] = list

    new_node = {:node, left_node, right_node}
    sum = left_node_freq+right_node_freq

    list = [{new_node, sum}] ++ list

    list
    |> Enum.sort_by(&(elem(&1, 1)))
    |> make_tree()

  end






  def nodify_data([]), do: []
  def nodify_data([h | t]) do
    [{:node, {:data, h}, :nil, :nil} | nodify_data(t)]
  end


  def get_frequency_list_in_order(text) do
    list = count_frequency(text)
    list |> Enum.sort_by(&(elem(&1, 1)))
  end

  def count_frequency([]), do: []
  def count_frequency([h|t]) do
    {new_list, frequency} = count_and_remove([h | t], h)
    [{h, frequency} | count_frequency(new_list)]
  end


  def count_and_remove(list, element) do
    count_and_remove(list, element, 0, [])
  end

  def count_and_remove([], _, counter, new_list), do: {new_list, counter}

  def count_and_remove([h|t], h, counter, new_list) do
    count_and_remove(t, h, counter+1, new_list)
  end

  def count_and_remove([h|t], element, counter, new_list) do
    count_and_remove(t, element, counter, [h | new_list])
  end


end
