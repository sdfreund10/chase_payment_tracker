class Account < ApplicationRecord
  belongs_to :user
  validates :user, presence: true
  validates :account_number, presence: true, uniqueness: { scope: [:user_id] }
end
