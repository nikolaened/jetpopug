class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.references :account, foreign_key: true
      t.uuid :public_id
      t.decimal :fee, precision: 15, scale: 6, null: false, default: 0.0
      t.decimal :price, precision: 15, scale: 6, null: false, default: 0.0
      t.text :description

      t.timestamps
    end
  end
end
