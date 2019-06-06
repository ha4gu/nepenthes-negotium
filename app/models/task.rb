class Task < ApplicationRecord
  # Callback
  before_validation :set_deadline_date

  # Validation
  validates :subject, presence: true

  # Order
  default_scope { order(created_at: :desc) }

  private

  # 終了期限日が空だが終了期限時刻は定まっている場合に、終了期限日を今日の日付にする処理
  def set_deadline_date
    if self.deadline_time.present? && !self.deadline_date.present?
      self.deadline_date = Date.today
    end
  end
end
