class CreateUnprocessedEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :unprocessed_events do |t|
      t.text :raw_event
      t.integer :status, null: false, default: 0, index: true
      t.integer :retry_count
      t.timestamp :next_retry_at

      t.timestamps
    end
  end
end
