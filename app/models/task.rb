class Task < ApplicationRecord
  # Validation
  validates :subject, presence: true
end
