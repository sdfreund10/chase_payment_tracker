class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :details
      t.date :transaction_date
      t.date :posting_date
      t.string :description
      t.decimal :amount
      t.string :transaction_type
      t.decimal :balance
      t.string :type
      t.references :account, foreign_key: true
      t.timestamps
    end
  end
end
