class SimpleBillingLogic
  class << self
    def create_deposit_transaction(account, value, identificator)
      ActiveRecord::Base.transaction do
        balance_entity = account.balance
        balance_entity.balance -= value
        billing_cycle = BillingCycle.current_cycle
        Transaction.create!(account: account, billing_cycle: billing_cycle,
                            credit: 0, debit: value, type: 'deposit',
                            description: "Receive fee from #{account.public_id} for task #{identificator} assignment")
      end
    end

    def create_payment_transaction(account, value, identificator)
      ActiveRecord::Base.transaction do
        balance_entity = account.balance
        balance_entity.balance += value
        billing_cycle = BillingCycle.current_cycle
        Transaction.create!(account: account, billing_cycle: billing_cycle,
                            credit: value, debit: 0, type: 'payment',
                            description: "Pay price to #{account.public_id} for task #{identificator} assignment")
      end
    end

    def create_withdraw_transaction(account, value)
      ActiveRecord::Base.transaction do
        balance_entity = account.balance
        balance_entity.balance = 0
        billing_cycle = BillingCycle.current_cycle
        Transaction.create!(account: account, billing_cycle: billing_cycle,
                            credit: value, debit: 0, type: 'withdraw',
                            description: "Give cash to #{account.public_id}")
      end
    end

  end
end