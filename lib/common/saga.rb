module Saga
  def unprocessed_commands
    @unprocessed_commands ||= []
  end

  private

  def deliver(command)
    unprocessed_commands << command
  end
end
