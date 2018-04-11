class Transaction < ApplicationRecord
  belongs_to :account
  validates :account, presence: true
  validates_uniqueness_of :description,
                          scope: %i(account_id posting_date balance)
end
