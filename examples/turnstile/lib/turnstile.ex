defmodule Turnstile do
  use GenFSM

  @moduledoc """
  A module that implement a turnstile that let a person enter if
  a coin has been inserted into the turnstile; no access will be
  granted if no coins has been inserted. If multiple coins are
  inserted it will only let one person through; it is greedy like
  that.

  Start the turnstile process using `start_link/0`

      iex> {:ok, pid} = Turnstile.start_link()
      {:ok, #PID<0.137.0>}

  The turnstile will start in the locked position. From the locked
  state it will accept the `insert_coin` input, as well as the
  `empty` and `enter` input--it will not let anyone pass though.

  If we try to empty the turnstile we will get `0`

      iex> Turnstile.empty(pid)
      0

  If we enter a coin it will be put into the memory of the state
  machine:

      iex> Turnstile.insert_coin(pid)
      :ok

  And we are allowed to enter the turnstile:

      iex> Turnstile.enter(pid)
      :access_allowed

  We can empty the bank of the turnstile to verify that there is
  a coin.

      iex> Turnstile.empty(pid)
      1

  Emptying it again will yield `0` because `Turnstile.empty/1`
  will reset the bank.

  Let's try entering the turnstile. When it is in the locked
  position we will get an `:access_denied` when using
  `Turnstile.enter/1`.

      iex> Turnstile.enter(pid)
      :access_denied

  When someone enters the turnstile while in the unlocked state
  it will go back to the locked state, but the bank will contain
  the coin:

      iex> Turnstile.enter(pid)
      :access_denied
      iex> Turnstile.empty(pid)
      1

  The source code had been annotated with comments. Please open
  an issue if something is not clear.
  """

  # Initialize the turnstile state machine with zero coins
  def start_link do
    GenFSM.start_link(__MODULE__, 0)
  end

  # Public API
  #
  # The user can enter and insert_coins into our turnstile. The
  # outcome of these actions depends on the state of the turnstile
  # lock.
  def enter(pid) do
    GenFSM.sync_send_event(pid, :enter)
  end
  def empty(pid) do
    GenFSM.sync_send_event(pid, :empty)
  end
  def insert_coin(pid) do
    GenFSM.send_event(pid, :coin)
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
