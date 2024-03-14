class Payment < ApplicationRecord
  belongs_to :account
  belongs_to :billing_cycle
  has_one :transaction
end
