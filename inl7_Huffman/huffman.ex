defmodule Huffman do

  ## NODE = {:node, {:data, char, codepoint freq}, left_child, right_child}

  def sample_text() do
    'fffffffffffffffffffffffffffffffffffffffffffffeeeeeeeeeeeeeeeedddddddddddddccccccccccccbbbbbbbbbaaaaa'
  end

  def sample_text2() do
    'cheesecake'
  end

  def run(i) do
    message = read("test.txt", 0, i)
    frequency_list = get_frequency_list_in_order(message)
    |> leafify_data()
    tree = make_tree(frequency_list)
    encoding_table = find_and_store_all_leafs(tree, [], [])
    encoded_message = encode(message, encoding_table)
    decoded_message = decode_message(encoded_message,encoding_table)
    message = decoded_message
  end

  def run(bits) do
    message = mont_read("kallocain.txt", bits)
    frequency_list = get_frequency_list_in_order(message)
    |> leafify_data()
    tree = make_tree(frequency_list)
    encoding_table = find_and_store_all_leafs(tree, [], [])
    encoded_message = encode(message, encoding_table)
    decoded_message = decode_message(encoded_message,encoding_table)

  end

  def encode([], _encoding_table), do: []
  def encode([char | t], encoding_table) do
    {_char ,_charcode, code} = List.keyfind(encoding_table, char, 1)
    code ++ encode(t, encoding_table)
  end

  def decode_message([], _), do: []
  def decode_message(encoded_message, encoding_table) do
    {char, rest} = decode(encoded_message, encoding_table, 1)
    [char | decode_message(rest, encoding_table)]
  end

  def decode(encoded_message, encoding_table, n) do
    {code, rest} = Enum.split(encoded_message,n)
    case List.keyfind(encoding_table, code, 2) do
      {_char, char, _code} ->
        {char,rest}

      nil ->
        decode(encoded_message, encoding_table, n+1)
    end
  end

  def tree(frequency_list) do
    make_tree(frequency_list)
  end


  def make_tree([{root, _freq}]), do: root

  def make_tree(list) do
    [{left_node, left_node_freq} | list] = list
    [{right_node, right_node_freq} | list] = list

    new_node = {:node, left_node, right_node}
    sum = left_node_freq+right_node_freq

    list = [{new_node, sum}] ++ list

    list
    |> Enum.sort_by(&(elem(&1, 1)))
    |> make_tree()
  end

  def find_and_store_all_leafs({:node, left, right},path, list) do
    list = find_and_store_all_leafs(left, path++[0], list)
    list = find_and_store_all_leafs(right,path++[1], list)
  end

  def find_and_store_all_leafs({:leaf, char}, path, list) do
    [{List.to_string([char]),char,path}|list]
  end




  def leafify_data([]), do: []
  def leafify_data([{datacode, freq} | t]) do
    [{{:leaf, datacode}, freq} | leafify_data(t)]
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

  def read(file, start, length) do
    {:ok, file} = :file.open(file, [:read, :utf8])
    {:ok, data} = :file.pread(file, start, length)
    :file.close(file)
    case :unicode.characters_to_list(data, :utf8) do
    {:incomplete, list, _} ->
      list
    list ->
      list
    end
  end

  def mont_read(file,bits) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, bits)
    File.close(file)
    case :unicode.characters_to_list(binary, :utf8) do
    {:incomplete, list, _} ->
      list
    list ->
      list
    end
  end




end
