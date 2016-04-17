# GenFSM Turnstile Example

Have a look at the module documentation in `lib/turnstile.ex`

Load the project up in IEX after fetching the dependencies from hex.pm:

``` bash
$ mix deps.get
$ iex -S mix
```

`Turnstile` should be available. Use the `h/1` function to read about the example:

``` elixir
iex(0)> h Turnstile
```

Notice that the state machine will crash if the turn-stile is emptied while in the unlocked state.
