class Transaction < ApplicationRecord
  belongs_to :account
  validates :account, presence: true
end
