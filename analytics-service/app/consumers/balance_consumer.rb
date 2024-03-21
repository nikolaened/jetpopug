# frozen_string_literal: true

class BalanceConsumer < ApplicationConsumer

  def consume
    messages.each do |message|
      payload = message.payload
      event_name = payload["event_name"]
      event_version = payload["event_version"]
      data = payload["data"]

      case [event_name, event_version]
      when ["BalanceSnapshotTaken", 1], ["BalanceSnapshotTaken", nil]
        with_validation(message, 'balances.snapshot_taken') do
          account = Account.find_by_public_id(data['account_public_id'])
          DailyBalance.create!(account: account, balance: data['balance'], date: data['date'])
        end
      when ["BalanceChanged", 1], ["BalanceChanged", nil]
        with_validation(message, 'balances.changed') do
          account = Account.find_by_public_id(data['account_public_id'])
          BillingEvent.create!(account: account, debit: data['debit'], credit: data['credit'],
                               event_type: data['type'], description: payload['event_id'])
        end
      else
        handle_unprocessed(message)
      end
    end
  end
end
