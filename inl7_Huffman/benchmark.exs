defmodule BenchMark do

  def bench() do bench(10) end

  def bench(n) do

    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024, 16*1024, 32*1024, 64*1024, :all]
    :io.format("# benchmark of Huffman:\n")
    :io.format("~8.s~12.s\n", ["bitsUsed", "result"])
    Enum.each(ls, fn (i) ->
      {i, tla} = bench(i, n)
      :io.format("~6.w&~12.2f\\\\\n", [i,tla/n])
    end)

    :ok
  end

  def bench(bit_size, iterations) do
      result = run_huffman2(bit_size, iterations)
      {bit_size, result}
  end

  def run_huffman(bit_sizes, 1, start) do
    {result, _} = :timer.tc(fn() -> Huffman.run(start, bit_sizes) end)
    result
  end
  def run_huffman(bit_sizes, iterator, start) do
    {result, _} = :timer.tc(fn() -> Huffman.run(start, bit_sizes) end)
    result + run_huffman(bit_sizes, iterator-1, start+bit_sizes)
  end


  def run_huffman2(bits, 1) do
    {result, _} = :timer.tc(fn() -> Huffman.run(bits) end)
     result
  end
  def run_huffman2(bits, iterator) do
    {result, _} = :timer.tc(fn() -> Huffman.run(bits) end)
    result + run_huffman2(bits, iterator-1)
  end









end
