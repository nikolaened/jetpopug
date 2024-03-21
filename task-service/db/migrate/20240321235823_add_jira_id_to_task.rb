class AddJiraIdToTask < ActiveRecord::Migration[7.1]
  def up
    add_column :tasks, :jira_id, :string, null: true
  end

  def down
    remove_column :tasks, :jira_id
  end
end
