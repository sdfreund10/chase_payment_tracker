class EnforceDatabaseConstraints < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, :email
    add_index :users, :email, unique: true
    add_index :accounts, %i(account_number user_id), unique: true
    add_index(
      :transactions, %i(description account_id posting_date balance), unique: true,
      name: "index_transactions_on_desc_and_account_and_date_and_balance"
    )
  end
end
