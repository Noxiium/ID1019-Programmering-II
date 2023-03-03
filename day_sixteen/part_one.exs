defmodule PartOne do
  ## ex {:DD, 20, [:CC, :AA, :EE]}

  def task(t) do
    start = :AA

    rows = File.stream!("test.csv")
    map = Map.new(parse(rows))
    IO.inspect(map)
    closed = Enum.map((Enum.filter(map, fn({_,{rate,_}}) -> rate != 0 end)), fn({valve, _}) -> valve end)

  end





  def insert_valve_to_a_list([], valve), do: [valve]
  def insert_valve_to_a_list(list, valve), do: [valve | list]
  def parse(input) do
    Enum.map(input, fn(row) ->
      [valve, rate, valves] = String.split(String.trim(row), ["=", ";"])
      [_Valve, valve | _has_flow_rate ] = String.split(valve, [" "])
      valve = String.to_atom(valve)
      {rate,_} = Integer.parse(rate)
      [_, _tunnels,_lead,_to,_valves| valves] = String.split(valves, [" "])
      valves = Enum.map(valves, fn(valve) -> String.to_atom(String.trim(valve,",")) end)
      {valve, {rate, valves}}
    end)
  end
end
