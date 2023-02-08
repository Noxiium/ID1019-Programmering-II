defmodule Hanoi do


  def solve(n) do
    IO.write("Steps to solve with #{n} disks:\n")
    startTower =  {:a, 1, n}
    middleTower = {:b, 2, 0}
    goalTower =   {:c, 3, 0}
    hanoiPrint(n, startTower, goalTower, middleTower)
  end

  def solve2(n) do

    list = hanoiList(n, :a, :c, :b)
    IO.write("Total moves: #{Enum.count(list)}\nSteps to solve with #{n} disks:\n")
    list
  end


  def hanoiList(0, _, _, _) do
    []
  end

  def hanoiList(n, startTower, goalTower, auxTower) do
    hanoiList(n-1, startTower, auxTower, goalTower) ++
    [{:move, startTower, goalTower}] ++
    hanoiList(n-1, auxTower, goalTower, startTower)

  end



  def hanoiPrint(0, _, _, _) do
    IO.write("--------------------------------\n")
  end


  def hanoiPrint(n, startTower, goalTower, auxTower) do
    hanoiPrint(n-1, startTower, auxTower, goalTower)
    startTower = updateTowerValuesMinus(startTower)
    goalTower = updateTowerValuesAdd(goalTower)
    IO.puts("Move #{startTower|> elem(0)} -> #{goalTower|> elem(0)}")
    ##print(startTower, goalTower, auxTower)
    hanoiPrint(n-1, auxTower, goalTower, startTower)
  end


  def printPrint(t1, t2, t3) do
    list = [t1, t2, t3]
    sorted =list |> Enum.sort_by(&(elem(&1,1)))
    IO.inspect(sorted)

  end

  def updateTowerValuesAdd({v,n,number}) do
    {v,n,number+1}
  end

  def updateTowerValuesMinus({v,n,number}) do
    {v,n,number-1}
  end


end
