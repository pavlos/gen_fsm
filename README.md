<img align="right" src="http://i.imgur.com/OEtTdfe.png">

# GenFSM

Elixir wrapper around Erlang's OTP gen_fsm.


## Motivation

Elixir [deprecated](https://github.com/elixir-lang/elixir/commit/455eb4c4ace81ce60b347558f9419fe3c33d8bf7)
its wrapper around OTP's gen_fsm from the standard library because it is difficult to understand and suggested that
developers seek other finite state machine implementations.

This is understandable, but some of us still need/prefer to use the OTP gen_fsm.

I took the basis of Elixir's old
[GenFSM.Behaviour](https://github.com/elixir-lang/elixir/blob/a6f048b3de4a971c15fc8b66397cf2e4597793cb/lib/elixir/lib/gen_fsm/behaviour.ex)
and added some additional convenience methods.  Currently missing are the `enter_loop` methods.

## Usage

The following example implement a simple state machine with two states, `martin` and `paul`. The state machine will initialize into the `martin` state, when the state machine receive `:hello` as the input it will transition between the states, from `martin` to `paul` and `"Hello, Paul"` will get printed to the console.

```elixir
defmodule Conversation do
  use GenFSM

  def start_link() do
    GenFSM.start_link(__MODULE__, :na)
  end

  def hello(pid) do
    GenFSM.send_event(pid, :hello)
  end

  def init(:na), do: {:ok, :martin, nil}

  def martin(:hello, nil) do
    IO.puts "Hello, Paul"
    {:next_state, :paul, nil}
  end

  def paul(:hello, nil) do
    IO.puts "Hello, Martin"
    {:next_state, :martin, nil}
  end
end
```

A conversation could go like this:

``` elixir
iex(2)> {:ok, pid} = Conversation.start_link
{:ok, #PID<0.165.0>}
iex(3)> Conversation.hello pid
Hello, Paul
:ok
iex(4)> Conversation.hello pid
Hello, Martin
:ok
iex(5)>
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add gen_fsm to your list of dependencies in `mix.exs`:

        def deps do
          [{:gen_fsm, "~> 0.1.0"}]
        end

## Documentation

Complete [API documentation](http://erlang.org/doc/man/gen_fsm.html) can be found at
http://erlang.org/doc/man/gen_fsm.html
and OTP [design principal documentation](http://erlang.org/doc/design_principles/fsm.html)
lives at http://erlang.org/doc/man/gen_fsm.html
