class AddTokenAndIsAdminFlagToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :token, :string, null: false
    add_column :users, :is_admin, :boolean, null: false, default: false
  end
end
