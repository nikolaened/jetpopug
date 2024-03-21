class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :billing_cycle

  enum transaction_types: {
    withdraw: 'withdraw',
    payment: 'payment',
    deposit: 'deposit',
  }
end
