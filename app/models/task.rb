class Task < ApplicationRecord
  # Validation
  validates :subject, presence: true

  # Order
  default_scope { order(created_at: :desc) }
end
