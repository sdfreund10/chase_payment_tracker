class User < ApplicationRecord
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password
end
