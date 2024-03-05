class AddFullNameToAccount < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :full_name, :string
    add_column :accounts, :position, :string
    add_column :accounts, :active, :boolean, default: true
  end
end
