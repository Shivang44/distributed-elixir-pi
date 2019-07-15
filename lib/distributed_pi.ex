defmodule DistributedPi do

  def main(args \\ []) do
    # To keep things simple, we will use comma separated arguments: [master/worker],[node_name]
    args
    |> List.to_tuple()
    |> start_server()
  end

  defp start_server(args) do
    case args do
      {"master", node_name, digits} ->
        node_name |> String.to_atom |> Node.start
        digits |> String.to_integer |> DistributedPi.Master.start
      {"worker", master_node_name, digits} ->
        6 |> :crypto.strong_rand_bytes |> Base.encode16 |> String.to_atom |> Node.start
        master_node_name |> String.to_atom |> Node.connect
        :global.sync()
        digits |> String.to_integer |> DistributedPi.Worker.start
    end
  end
end
