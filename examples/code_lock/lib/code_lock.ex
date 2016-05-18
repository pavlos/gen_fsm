defmodule CodeLock do
  use GenFSM

  def start_link(code) do
    GenFSM.start_link(__MODULE__, Enum.reverse(code))
  end

  def button(pid, digit) do
    IO.puts "beeep!"
    GenFSM.send_event(pid, {:button, digit})
  end

  def init(code) do
    {:ok, :locked, {[], code}}
  end

  def locked({:button, digit}, {so_far, code}) do
    IO.inspect {:state, [digit | so_far], code}
    case [digit | so_far] do
      ^code ->
        # do_unlock(...)
        IO.puts "unlocked!"
        {:next_state, :open, {[], code}, 1000}

      incomplete when length(incomplete) < length(code) ->
        IO.puts "awaiting more digits"
        {:next_state, :locked, {incomplete, code}}

      _wrong ->
        IO.puts "wrong!"
        {:next_state, :locked, {[], code}}
    end
  end

  def open(:timeout, state) do
    # do_lock(...)
    IO.puts "SLAM! locked!"
    {:next_state, :locked, state}
  end
end
