class User < ApplicationRecord
  # bcrypt
  has_secure_password

  # Association
  has_many :tasks

  # Validation
  validates :name,  presence: true
  validates :email, presence: true
end
