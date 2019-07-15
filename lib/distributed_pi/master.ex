defmodule DistributedPi.Master do
  use GenServer
  alias Decimal, as: D
  @work_size 10 # How much work to send at a time

  def start(digits) do
    D.set_context(%D.Context{D.get_context | precision: div(digits * 4, 3)})
    pi = D.new(0)
    remaining_digits = Enum.to_list(0..digits)
    power = Decimal.new(1) # Cache power of sixteens so we don't have to recompute
    {:ok, pid} = GenServer.start_link(__MODULE__, {pi, remaining_digits, power})
    :global.register_name(:master, pid)

    IO.puts "Started master node"
    :timer.sleep(:infinity)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get_work, _form, state) do
    {pi, remaining_digits, power} = state
    case length(remaining_digits) do
      0 ->
        IO.puts "Finished calculating pi: #{D.to_string(pi)}"
        {:reply, :done, state}
        System.stop(0)
      _ ->
        # IO.puts("Giving more work")
        {worker_digits, next_digits} = Enum.split(remaining_digits, @work_size)
        multiply_power_by = Decimal.new(Kernel.inspect(:math.pow(16, length(worker_digits) + 1)))
        new_power = D.mult(power, multiply_power_by)
        {:reply, {worker_digits, power}, {pi, next_digits, new_power}}
    end
  end

  def handle_call({:upload_work, computed_work}, _from, state) do
    {pi, remaining_digits, power} = state
    new_pi = D.add(pi, computed_work)
    {:reply, :ok, {new_pi, remaining_digits, power}}
  end



 end
