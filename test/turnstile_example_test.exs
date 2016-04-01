defmodule GenFSM.TurnstileExampleTest do
  use ExUnit.Case

  # A module that implement a turnstile that let a person enter if
  # a coin has been inserted into the turnstile; no access will be
  # granted if no coins has been inserted. If multiple coins are
  # inserted it will only let one person through, it is greedy like
  # that.
  defmodule Turnstile do
    use GenFSM

    # Initialize the turnstile state machine with zero coins
    def start_link do
      GenFSM.start_link(__MODULE__, 0)
    end

    # Public API
    # The user can enter and insert_coins into our turnstile. The
    # outcome of these actions depends on the state of the turnstile
    # lock.
    def enter(pid) do
      GenFSM.sync_send_event(pid, :enter)
    end
    def insert_coin(pid) do
      GenFSM.send_event(pid, :coin)
    end
    def empty(pid) do
      GenFSM.sync_send_event(pid, :empty)
    end

    # Internal API
    def init(number_of_coins) do
      # Initialize the turnstile state machine in the locked state.
      # The state machine is initialized with a given number of
      # coins in its bank.
      {:ok, :locked, number_of_coins}
    end

    def unlocked(:coin, state) do
      # If another coin is inserted we will just eat the coin.
      {:next_state, :unlocked, state + 1}
    end
    def unlocked(:enter, _from, state) do
      # One can enter the door when it is unlocked, but it will switch
      # state to locked when the door has been entered.
      {:reply, :access_allowed, :locked, state}
    end

    def locked(:coin, state) do
      # Increment the bank and set the state to unlocked, allowing
      # someone to enter.
      {:next_state, :unlocked, state + 1}
    end
    def locked(:enter, _from, state) do
      # The door will not let anyone enter before it has been unlocked
      # by inserting a coin. Entering in this state will not to
      # anything.
      {:reply, :access_denied, :locked, state}
    end
    def locked(:empty, _from, state) do
      # The turnstile can be emptied when it is locked. This will reset
      # the bank to zero and return the number of coins (we do not take
      # authorization into consideration here). When the turnstile is
      # emptied it will remain in the locked state.
      {:reply, state, :locked, 0}
    end
  end

  test "turnstile example" do
    assert {:ok, pid} = Turnstile.start_link()

    # turnstile bank should initialize as empty
    assert Turnstile.empty(pid) == 0

    # let's try to enter without inserting a coin
    assert Turnstile.enter(pid) == :access_denied

    # lets insert some coins
    Turnstile.insert_coin(pid)
    Turnstile.insert_coin(pid)
    Turnstile.insert_coin(pid)

    # it should allow entry once; the second time it should deny
    assert Turnstile.enter(pid) == :access_allowed
    assert Turnstile.enter(pid)  == :access_denied

    # let's check the bank!
    assert Turnstile.empty(pid) == 3
    # turnstile bank should now be empty
    assert Turnstile.empty(pid) == 0
  end
end
