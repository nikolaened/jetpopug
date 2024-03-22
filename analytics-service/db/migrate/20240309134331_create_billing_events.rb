class CreateBillingEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :billing_events do |t|
      t.references :account, foreign_key: true
      t.uuid :public_id
      t.decimal :debit, precision: 15, scale: 6
      t.decimal :credit, precision: 15, scale: 6
      t.text :description

      t.timestamps
    end
  end
end
