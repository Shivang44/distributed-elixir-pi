defmodule DistributedPi do
  alias Decimal, as: D
  @d1 D.new(1)
  @d2 D.new(2)
  @d4 D.new(4)
  @d5 D.new(5)
  @d6 D.new(6)
  @d8 D.new(8)
  @d16 D.new(16)

  def pi(k) do
    D.set_context(%D.Context{D.get_context | precision: div(k * 4, 3)})
    Enum.to_list(0..k) |> Enum.reduce(D.new(0), fn x, pi ->
      D.add(pi, kth(x))
    end)
  end

  def kth(k) do
    coeff = D.from_float(:math.pow(16, k))
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
