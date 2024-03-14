class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :billing_cycle

  enum type: {
    withdraw: 'withdraw',
    payment: 'payment',
    deposit: 'deposit',
  }
end
