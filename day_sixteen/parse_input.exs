defmodule ParseInput do

  ## ex {:DD, 20, [:CC, :AA, :EE]}

  def parse() do
    rows = File.stream!("test.csv")
    string_into_data_structure(rows)
  end

  def string_into_data_structure(input) do
    Enum.map(input, fn(row) ->
      [valve, rate, valves] = String.split(String.trim(row), ["=", ";"])
      [_Valve, valve | _has_flow_rate ] = String.split(valve, [" "])
      valve = String.to_atom(valve)
      {rate,_} = Integer.parse(rate)
      [_, _tunnels,_lead,_to,_valves| valves] = String.split(valves, [" "])
      valves = Enum.map(valves, fn(valve) -> String.to_atom(String.trim(valve,",")) end)
      {valve, rate, valves}
    end)
  end
end
