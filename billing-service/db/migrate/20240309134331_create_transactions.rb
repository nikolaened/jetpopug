class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :account, foreign_key: true
      t.uuid :public_id
      t.decimal :debit, precision: 15, scale: 6
      t.decimal :credit, precision: 15, scale: 6
      t.text :description
      t.references :billing_cycle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
