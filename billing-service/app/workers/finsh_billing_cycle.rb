# frozen_string_literal: true

module Worker
  class FinshBillingCycle
    def self.process
      ActiveRecord::Base.transaction do
        billing_cycle = BillingCycle.current_cycle
        Account.all.each do |account|
          account_balance = account.balance
          next if account_balance.balance <= 0

          Payment.new(account: account,
                      pay_status: false,
                      amount: account_balance.balance,
                      billing_cycle: billing_cycle)
          SimpleBillingLogic.create_withdraw_transaction(account, account_balance.balance)
          account_balance.update!(balance: 0)
        end
        billing_cycle.update!(closed_at: Time.now,
                              opened: false)
        BillingCycle.create_cycle!
      end
      AnalyticsEventsService.share_current_balances
    end
  end
end
