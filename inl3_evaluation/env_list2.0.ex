defmodule EnvList2 do

  def new() do [] end

  def add(enviroment, key, value) do
    [{key, value} | enviroment]
  end

  def lookup(enviroment, key) do
    List.keyfind(enviroment, key, 0)
  end
end
