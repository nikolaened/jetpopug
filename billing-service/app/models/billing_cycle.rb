class BillingCycle < ApplicationRecord
  has_many :transactions
  BILLING_CYCLE_PERIOD = :week

  def self.current_cycle
    cycle = BillingCycle.where(opened: true).first
    return cycle if cycle.present?

    start_time, finish_time = period
    cycle = BillingCycle.new(description: "Created on use (#{Time.now.to_i})",
                             start_time: start_time, finish_time: finish_time)
    cycle
  end

  def self.create_cycle!
    start_time, finish_time = period
    BillingCycle.new(description: "Created on schedule (#{start_time.to_i})",
                     start_time: start_time, finish_time: finish_time)
  end

  def self.period
    case BILLING_CYCLE_PERIOD
    when :week then [Time.now.beginning_of_week, Time.now.end_of_week]
    else raise("Unsupported period")
    end
  end
end
