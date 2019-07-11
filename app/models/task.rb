class Task < ApplicationRecord
  # Association
  belongs_to :user

  # Callback
  before_validation :set_deadline_date, :switch_labels
  after_commit :update_expire_counts

  # Validation
  validates :subject,  presence: true
  validates :status,   presence: true, inclusion: { in: %w(created started finished) }
  validates :priority, presence: true, inclusion: { in: %w(low middle high) }

  # Custom scopes for ransack
  scope :sort_by_deadline_asc,  -> { order("deadline_date  ASC NULLS LAST, deadline_time DESC NULLS LAST") }
  scope :sort_by_deadline_desc, -> { order("deadline_date DESC NULLS LAST, deadline_time ASC  NULLS FIRST") }

  # status, handled by statefulEnum
  enum status: { created: 0, started: 1, finished: 2 } do
    event :start do
      transition created: :started
    end

    event :finish do
      transition all - [:finished] => :finished
    end
  end

  # priority, handled by statefulEnum
  enum priority: { low: 2, middle: 3, high: 4 } do
    event :to_low do
      transition all - [:low] => :low
    end

    event :to_middle do
      transition all - [:middle] => :middle
    end

    event :to_high do
      transition all - [:high] => :high
    end
  end

  # 終了期限（ビューでの表示用）
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

  # 終了期限（期限切れチェック用）
  def deadline_for_expire_check
    if @deadline_for_expire_check
      @deadline_for_expire_check
    elsif self.deadline_date.present? && self.deadline_time.present?
      Time.zone.parse("#{self.deadline_date} #{self.deadline_time.to_s(:time)}")
    elsif self.deadline_date.present?
      Time.zone.parse("#{self.deadline_date.tomorrow}")
    else
      nil
    end
  end

  # labels, handled by ActsAsTaggableOn
  acts_as_ordered_taggable_on :labels

  private

  # 終了期限日が空だが終了期限時刻は定まっている場合に、終了期限日を今日の日付にする処理
  def set_deadline_date
    if self.deadline_time.present? && self.deadline_date.blank?
      self.deadline_date = Time.zone.today
    end
  end

  # オーナーなしラベルをオーナーありラベルに貼り直す処理
  def switch_labels
    # self.label_listにはユーザが入力したラベルの一覧が格納されている。
    # これを現在のログインユーザーをオーナーとしたラベルとして貼り直す。
    # ただしこの段階ではまだ保存・更新はさせない。
    self.user&.tag(self, with: self.label_list, on: :labels, skip_save: true)
    # オーナーなしのラベルはクリアする
    self.label_list = nil
  end

  # 終了期限切れタスク数の更新処理
  def update_expire_counts
    CountExpiringTasksJob.perform_later(self.user.id)
  end
end
