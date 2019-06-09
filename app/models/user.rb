class User < ApplicationRecord
  # bcrypt
  has_secure_password

  # Validation
  validates :name,  presence: true
  validates :email, presence: true
end
