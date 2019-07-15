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
  D.set_context(%D.Context{D.get_context | precision: div(digits * 4, 3)})
  master_pid = :global.whereis_name(:master)
  work(master_pid)
 end

 def work(pid) do
  case GenServer.call(pid, :get_work) do
    :done -> System.stop(0)
    {worker_digits, power} ->
      IO.puts "Got more work"
      computed_work = pi(worker_digits, power)
      {:ok, _} = GenServer.call(pid, {:upload_work, computed_work})
      work(pid)
  end
 end


 def pi(digits, power) do
  case length(digits) do
    0 -> D.new(0)
    _ ->
      [digit | tail] = digits
      decimal_power = D.new(power)
      digit |> kth(decimal_power) |> D.add(pi(tail, power * 16))

  end
  # digits |> Enum.reduce(D.new(0), fn x, pi ->
  #    D.add(pi, kth(x, power))
  #  end)

 end

 def kth(k, power) do
  coeff = D.new(power)
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

   D.div(result, coeff)
 end

end
