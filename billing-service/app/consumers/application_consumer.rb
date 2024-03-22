# frozen_string_literal: true

# Application consumer from which all Karafka consumers should inherit
# You can rename it if it would conflict with your current code base (in case you're integrating
# Karafka with other frameworks)
class ApplicationConsumer < Karafka::BaseConsumer
  def with_validation(event, type, version: 1, &block)
    if SchemaRegistry.validate_event(event, type, version: version).success?
      block.call
    else
      handle_unprocessed(event)
    end
  end

  def handle_unprocessed(event)
    puts "Unsupported event"
    UnprocessedEvent.create!(raw_event: event)
  end
end
