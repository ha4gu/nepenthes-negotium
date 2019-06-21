FactoryBot.define do
  factory :user, class: User do
    name { "testuser" }
    email { "test@example.com" }
    password { "P@ssw0rd" }
  end
end
