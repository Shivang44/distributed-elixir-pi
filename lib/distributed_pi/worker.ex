defmodule DistributedPi.Worker do
  alias Decimal, as: D
  @d1 D.new(1)
  @d2 D.new(2)
  @d4 D.new(4)
  @d5 D.new(5)
  @d6 D.new(6)
  @d8 D.new(8)
  @d16 D.new(16)

 def start(digits) do
  IO.puts "Started worker"
  D.set_context(%D.Context{D.get_context | precision: div(1000 * 4, 3)})

  master_pid = :global.whereis_name(:master)
  work(master_pid)
 end

 def work(pid) do
  case GenServer.call(pid, :get_work) do
    :done ->
      "Pi calculation completed."
    {worker_digits, power} ->
      computed_work = pi(worker_digits, power)
      GenServer.call(pid, {:upload_work, computed_work})
      IO.puts "Computed and uploaded partial pi result."
      work(pid)
  end
 end


 def pi(digits, power) do
  D.set_context(%D.Context{D.get_context | precision: div(1000 * 4, 3)})

  case length(digits) do
    0 -> D.new(0)
    _ ->
      [digit | tail] = digits
      digit |> kth(power) |> D.add(pi(tail, D.mult(power, @d16)))

  end
 end

 def kth(k, power) do
  D.set_context(%D.Context{D.get_context | precision: div(1000 * 4, 3)})

   eight_k = D.mult(@d8, D.new(k))

   term_1 = D.div(@d4, D.add(eight_k, @d1))
   term_2 = D.div(@d2, D.add(eight_k, @d4))
   term_3 = D.div(@d1, D.add(eight_k, @d5))
   term_4 = D.div(@d1, D.add(eight_k, @d6))

   result =
   term_1
   |> D.sub(term_2)
   |> D.sub(term_3)
   |> D.sub(term_4)

   D.div(result, power)
 end

end
