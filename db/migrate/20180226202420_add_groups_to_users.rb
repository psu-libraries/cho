class AddGroupsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :group_list, :text, null: false, default: ''
    add_column :users, :groups_last_update, :datetime, null: true
  end
end
