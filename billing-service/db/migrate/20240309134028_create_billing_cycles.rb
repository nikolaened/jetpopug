class CreateBillingCycles < ActiveRecord::Migration[7.1]
  def change
    create_table :billing_cycles do |t|
      t.uuid :public_id
      t.text :description
      t.timestamp :start_time, null:false
      t.timestamp :finish_time
      t.timestamp :closed_at
      t.boolean :opened, null: false, default:true

      t.timestamps
    end
  end
end
