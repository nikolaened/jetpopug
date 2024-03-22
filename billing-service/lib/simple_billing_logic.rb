class SimpleBillingLogic
  class << self
    def create_deposit_transaction(account, value, identificator)
      transaction = ActiveRecord::Base.transaction do
        balance_entity = account.balance
        balance_entity.update!(balance: balance_entity.balance - value)
        billing_cycle = BillingCycle.current_cycle
        Transaction.create!(account: account, billing_cycle: billing_cycle,
                            credit: 0, debit: value, transaction_type: 'deposit',
                            description: "Receive fee from #{account.public_id} for task #{identificator} assignment")
      end
      BillingEventSender.send_event(account.public_id, credit: transaction.debit, debit: transaction.credit,
                                    type: transaction.transaction_type)
    end

    def create_payment_transaction(account, value, identificator)
      transaction = ActiveRecord::Base.transaction do
        balance_entity = account.balance
        balance_entity.update!(balance: balance_entity.balance + value)
        billing_cycle = BillingCycle.current_cycle
        Transaction.create!(account: account, billing_cycle: billing_cycle,
                            credit: value, debit: 0, transaction_type: 'payment',
                            description: "Pay price to #{account.public_id} for task #{identificator} assignment")
      end
      BillingEventSender.send_event(account.public_id, credit: transaction.debit, debit: transaction.credit,
                                    type: transaction.transaction_type)
    end

    def create_withdraw_transaction(account, value)
      transaction = ActiveRecord::Base.transaction do
        balance_entity = account.balance
        balance_entity.update!(balance: 0)
        billing_cycle = BillingCycle.current_cycle
        Transaction.create!(account: account, billing_cycle: billing_cycle,
                            credit: value, debit: 0, transaction_type: 'withdraw',
                            description: "Give cash to #{account.public_id}")
      end
      BillingEventSender.send_event(account.public_id, credit: transaction.debit, debit: transaction.credit,
                                    type: transaction.transaction_type)
    end

  end
end