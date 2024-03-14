class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :account, null: false, foreign_key: true
      t.boolean :pay_status
      t.decimal :amount, precision: 15, scale: 6
      t.timestamp :pay_time
      t.references :billing_cycle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
