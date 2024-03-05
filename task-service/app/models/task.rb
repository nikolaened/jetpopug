class Task < ApplicationRecord
  belongs_to :account

  enum status: {
    assigned: 1,
    completed: 2
  }

  validates_presence_of :account_id

  def finished?
    self.status_changed? && completed?
  end
end
