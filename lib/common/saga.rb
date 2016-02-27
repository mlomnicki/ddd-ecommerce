module Saga
  def unprocessed_commands
    @unprocessed_commands ||= []
  end

  def clear_unprocessed_commands
    @unprocessed_commands.clear
  end

  def unpublished_events
    []
  end

  def apply_old_event(event)
    handle(event)
  end

  private

  def deliver(command)
    unprocessed_commands << command
  end
end
