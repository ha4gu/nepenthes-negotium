class User < ApplicationRecord
  # bcrypt
  has_secure_password

  # Association
  has_many :tasks, dependent: :delete_all

  # Validation
  validates :name,  presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX},
            uniqueness: { case_sensitive: false }

  # Callback
  before_update  :avoid_to_demote_last_admin
  before_destroy :avoid_to_delete_last_admin

  # Error
  class LastAdminError < StandardError
  end

  # ActsAsTaggableOn
  acts_as_tagger

  private

  # prevent to update the last admin to normal user
  def avoid_to_demote_last_admin
    if User.where(admin: true).size == 1 && !self.admin && self.admin_was
      raise LastAdminError
    end
  end

  # prevent to delete the last admin
  def avoid_to_delete_last_admin
    if User.where(admin: true).size == 1 && self.admin?
      raise LastAdminError
    end
  end
end
