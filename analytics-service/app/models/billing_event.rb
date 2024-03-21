class BillingEvent < ApplicationRecord
  belongs_to :account

  enum event_type: {
    withdraw: 'withdraw',
    payment: 'payment',
    deposit: 'deposit',
  }
end
