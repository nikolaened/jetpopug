class UnprocessedEvent < ApplicationRecord
  enum status: { not_processed: 0, processed: 1 }
end
