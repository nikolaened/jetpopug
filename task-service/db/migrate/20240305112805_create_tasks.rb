class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.text :description
      t.integer :status
      t.timestamp :finished_at
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
