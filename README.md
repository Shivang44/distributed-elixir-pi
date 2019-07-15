# DistributedPi

For my hackday project I wanted to learn more about elixir, specifically the distributed/OTP parts of it.

To accomplish this, I created a distributed PI computation cluster in Elixir. It works by creating a master node that accepts the number of digits of PI to compute, and distributes this work to workers in the cluster of nodes (e.g. node 1 computes the first 10 digits, node 2 computes the next 10, etc).

Then workers that connect to this master node can request work from the master node, compute partial PI results (I used the [Bailey–Borwein–Plouffe](https://en.wikipedia.org/wiki/Bailey%E2%80%93Borwein%E2%80%93Plouffe_formula) formula), and upload them to the master node, which merges the result and outputs PI!

I think this is really cool because all of this is possible without redis or any type of messaging/job queue, since Nodes in elixir can communicate via message passing directly and messages are automatically serialized/desearlized over the network. I learned a ton in this project and highly recommend others to try Elixir!

TODO:
- For higher number of digits of PI, this simply doesn't work. I'm still debugging this. I believe it's due to floating point precision math
- Testing on multiple machines. Nodes in Elixir can be launched in the same machine and across machines and they work they same, but I didn't get to actually test this due to time contraints.

Credits: I was influenced by this project, which used elixir to compute pi on rasberry pi's: https://github.com/pythonquick/elixirpi


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `distributed_pi` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:distributed_pi, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/distributed_pi](https://hexdocs.pm/distributed_pi).

