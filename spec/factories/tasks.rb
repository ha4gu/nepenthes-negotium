FactoryBot.define do
  factory :task, class: Task do
    subject { "New Task" }
    detail { "This is a new task." }
    user
  end
end
