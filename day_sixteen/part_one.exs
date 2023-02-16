defmodule PartOne do
  ## ex {:DD, 20, [:CC, :AA, :EE]}

  def run() do
    start = :AA
    list = ParseInput.parse()
  end






  def find_valve_in_list([], _) do :nil end
  def find_valve_in_list([{valve, flow_rate, neighborValves}| _], valve) do
    {valve, flow_rate, neighborValves}
  end
  def find_valve_in_list([_ | tail], valve) do
    find_valve_in_list(tail, valve)
  end

end
