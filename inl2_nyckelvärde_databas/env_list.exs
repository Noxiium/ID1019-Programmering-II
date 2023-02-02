defmodule EnvList do

  ## a map is an list with tuples.
  ## a tuple consist of an key of the type atom (:a, :b, :c etc.)
  ## and a value of the type integer.

  def new() do [] end

  def add([], key, value) do [{key,value}] end
  def add([{key, _}|t], key, value) do [{key,value}|t] end
  def add([d|t], key, value) do [d|add(t, key, value)] end

  def lookup([], _) do :nil end
  def lookup([{key, value}|_], key) do {key, value} end
  def lookup([_|t], key) do lookup(t, key) end

  def remove([], key) do [] end
  def remove([{key, _}|t], key) do t end
  def remove([d|t], key) do [d|remove(t, key)] end


end
