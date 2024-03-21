class BillingEvent < ApplicationRecord
  belongs_to :account

  enum type: {
    withdraw: 'withdraw',
    payment: 'payment',
    deposit: 'deposit',
  }
end
