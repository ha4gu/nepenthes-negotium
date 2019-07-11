class ExpireCount < ApplicationRecord
  # Association
  belongs_to :user

  # Validation
  validates :expired_count,  presence: true, numericality: { only_integer: true }
  validates :expiring_count, presence: true, numericality: { only_integer: true }
  validates :expiring_hours, presence: true, numericality: { only_integer: true }
end
