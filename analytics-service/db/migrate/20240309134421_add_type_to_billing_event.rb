class AddTypeToBillingEvent < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      CREATE TYPE billing_event_types AS ENUM ('withdraw', 'payment', 'deposit');
    SQL
    add_column :billing_events, :event_type, :billing_event_types, null: false, default: 'deposit'
  end

  def down
    remove_column :billing_events, :event_type
    execute <<-SQL
      DROP TYPE billing_event_types;
    SQL
  end
end