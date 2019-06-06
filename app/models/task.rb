class Task < ApplicationRecord
  # Callback
  before_validation :set_deadline_date

  # Validation
  validates :subject, presence: true

  # Scopes
  scope :create_asc,  -> { order(created_at: :asc) }
  scope :create_desc, -> { order(created_at: :desc) }
  scope :update_asc,  -> { order(updated_at: :asc) }
  scope :update_desc, -> { order(updated_at: :desc) }
  scope :deadline_asc,  -> { order("deadline_date  ASC NULLS LAST, deadline_time DESC NULLS LAST") }
  scope :deadline_desc, -> { order("deadline_date DESC NULLS LAST, deadline_time ASC  NULLS FIRST") }

  def deadline_for_show
    if @deadline_for_show
      @deadline_for_show
    elsif self.deadline_date.present? && self.deadline_time.present?
      "#{self.deadline_date.strftime("%Y/%m/%d")} #{self.deadline_time.to_s(:time)}"
    elsif self.deadline_date.present?
      self.deadline_date.strftime("%Y/%m/%d")
    else
      ""
    end
  end

  private

  # 終了期限日が空だが終了期限時刻は定まっている場合に、終了期限日を今日の日付にする処理
  def set_deadline_date
    if self.deadline_time.present? && !self.deadline_date.present?
      self.deadline_date = Date.today
    end
  end
end
