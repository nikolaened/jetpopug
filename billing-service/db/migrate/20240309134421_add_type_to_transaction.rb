class AddTypeToTransaction < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      CREATE TYPE transaction_types AS ENUM ('withdraw', 'payment', 'deposit');
    SQL
    add_column :transactions, :type, :transaction_types, null: false, default: 'deposit'
  end

  def down
    remove_column :transactions, :type
    execute <<-SQL
      DROP TYPE transaction_types;
    SQL
  end
end