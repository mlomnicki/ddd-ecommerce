module Sales
  class OrderSagaManager
    def initialize(repository, command_bus)
      @repository  = repository
      @command_bus = command_bus
    end

    def handle(saga_event)
      saga = repository.load(saga_event.order_id)
      saga.clear_unprocessed_commands
      saga.handle(saga_event)
      saga.unprocessed_commands.each do |command|
        command_bus.call(command)
      end
      repository.save(saga)
    end

    private

    attr_reader :repository, :command_bus
  end
end
