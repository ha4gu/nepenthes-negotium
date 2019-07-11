class CountExpiringTasksJob < ApplicationJob
  queue_as :default
  DEFAULT_HOURS = 24

  def perform(user_id)
    # エントリの読み込みまたは新規作成
    count_entry = ExpireCount.find_by(user_id: user_id) || ExpireCount.new(user_id: user_id)
    count_entry.expired_count = 0
    count_entry.expiring_count = 0
    count_entry.expiring_hours ||= DEFAULT_HOURS

    # カウント処理
    User.find(user_id).tasks.where.not(status: "finished").each do |task|
      deadline = task.deadline_for_expire_check
      if deadline.nil?
        next
      elsif Time.zone.now >= deadline
        count_entry.expired_count += 1
      elsif Time.zone.now.since(count_entry.expiring_hours.hours) >= deadline
        count_entry.expiring_count += 1
      end
    end

    # 上書き
    count_entry.save!
  end
end
