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

Just `use GenFSM` in your FSM module
```elixir
defmodule MyFSM do
  use GenFSM
  
  # TODO: add some better examples
end
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add gen_fsm to your list of dependencies in `mix.exs`:

        def deps do
          [{:gen_fsm, "~> 0.0.1"}]
        end

## Documentation

Complete [API documentation](http://erlang.org/doc/man/gen_fsm.html) can be found at 
http://erlang.org/doc/man/gen_fsm.html
and OTP [design principal documentation](http://erlang.org/doc/design_principles/fsm.html) 
lives at http://erlang.org/doc/man/gen_fsm.html
