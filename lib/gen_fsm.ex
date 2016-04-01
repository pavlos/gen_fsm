defmodule GenFSM do
  @doc false
  defmacro __using__(_) do
    quote location: :keep do
      @behaviour :gen_fsm

      def send_event(fsm, event) do
        :gen_fsm.send_event(fsm, event)
      end

      def send_all_state_event(fsm, event) do
        :gen_fsm.send_all_state_event(fsm, event)
      end

      def sync_send_event(fsm, event, timeout \\ 5000) do
        :gen_fsm.sync_send_event(fsm, event, timeout)
      end

      def sync_send_all_state_event(fsm, event, timeout \\ 5000) do
        :gen_fsm.sync_send_all_state_event(fsm, event, timeout)
      end

      def reply(caller, reply) do
        :gen_fsm.reply(caller, reply)
      end

      def send_event_after(time, event) do
        :gen_fsm.send_event_after(time, event)
      end

      def start_timer(time, message) do
        :gen_fsm.start_timer(time, message)
      end

      def cancel_timer(timer_ref) do
        :gen_fsm.cancel_timer(timer_ref)
      end

      @doc false
      def handle_event(event, state_name, state_data) do
        { :stop, {:bad_event, state_name, event}, state_data }
      end

      @doc false
      def handle_sync_event(event, from, state_name, state_data) do
        { :stop, {:bad_sync_event, state_name, event}, state_data }
      end

      @doc false
      def handle_info(_msg, state_name, state_data) do
        { :next_state, state_name, state_data }
      end

      @doc false
      def terminate(_reason, _state_name, _state_data) do
        :ok
      end

      @doc false
      def code_change(_old, state_name, state_data, _extra) do
        { :ok, state_name, state_data }
      end

      defoverridable [handle_event: 3, handle_sync_event: 4,
                      handle_info: 3, terminate: 3, code_change: 4]
    end
  end
end
