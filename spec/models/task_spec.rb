require "rails_helper"

RSpec.describe Task, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end

  # good pattern
  it "is valid with subject and user_id" do
    task = Task.new(
        subject: "TestTask",
        user_id: @user.id
        )
    expect(task).to be_valid
  end

  # full pattern
  it "is valid with subject, detail, deadline_date, deadline_time,
      status, priority, and user_id" do
    task = Task.new(
        subject: "TestTask",
        detail: "Task can have some detailed information herewith.",
        deadline_date: "2019-12-31",
        deadline_time: "23:59:59 +0900",
        status: "started",
        priority: "high",
        user_id: @user.id
    )
    expect(task).to be_valid
  end

  # subject
  it "is invalid without subject" do
    task = Task.new(subject: nil)
    task.valid?
    expect(task.errors[:subject]).to include("を入力してください")
  end

  it "is invalid with empty subject" do
    task = Task.new(subject: "")
    task.valid?
    expect(task.errors[:subject]).to include("を入力してください")
  end

  it "is invalid with blank subject" do
    task = Task.new(subject: "          ")
    task.valid?
    expect(task.errors[:subject]).to include("を入力してください")
  end

  # detail
  it "is valid without detail" do
    task = Task.new(detail: nil)
    task.valid?
    expect(task.errors[:detail]).to_not include("を入力してください")
  end

  # deadline_date
  it "is valid without deadline_date" do
    task = Task.new(deadline_date: nil)
    task.valid?
    expect(task.errors[:deadline_date]).to_not include("を入力してください")
  end

  it "won't accept inappropriate deadline_date" do
    task = Task.new(deadline_date: "2000-18-53")
    expect(task.deadline_date).to be_nil
  end

  # deadline_time
  it "is valid without deadline_time" do
    task = Task.new(deadline_time: nil)
    task.valid?
    expect(task.errors[:deadline_time]).to_not include("を入力してください")
  end

  it "is invalid with inappropriate time" do
    task = Task.new(deadline_time: "11:81:92 +0900")
    expect(task.deadline_date).to be_nil
  end

  # deadline_date and deadline_time
  it "sets today's date to deadline_date when deadline_time is set but deadline_date is not" do
    task = Task.create(
        subject: "TestTask",
        detail: "Task can have some detailed information herewith.",
        deadline_date: nil,
        deadline_time: "23:59:59 +0900",
        status: "started",
        priority: "high",
        user_id: @user.id
    )
    expect(task.deadline_date).to eq Date.current
  end

  # status
  it "raises error with irregular strings for status" do
    expect { Task.new(status: "eaten") }.to raise_error ArgumentError
  end

  # priority
  it "raises error with irregular strings for priority" do
    expect { Task.new(priority: "important") }.to raise_error ArgumentError
  end

  # user_id
  it "is invalid without user_id" do
    task = Task.new(user_id: nil)
    task.valid?
    expect(task.errors[:user]).to include("を入力してください")
  end

  # association
  it "returns user to whom it belongs" do
    task = Task.new(
        subject: "TestTask",
        user_id: @user.id
    )
    expect(task.user).to eq User.find_by_email("test@example.com")
  end
end
