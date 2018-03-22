class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :account_number, null: false
      t.string :type
      t.references :user, foreign_reference: true
      t.timestamps
    end
  end
end
