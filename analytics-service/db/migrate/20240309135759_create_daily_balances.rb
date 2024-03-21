class CreateDailyBalances < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_balances do |t|
      t.references :account, null: false, foreign_key: true
      t.decimal :balance, precision: 15, scale: 6, null: false, default: 0.0
      t.date :date, null: false, index: true

      t.timestamps
    end
  end
end
