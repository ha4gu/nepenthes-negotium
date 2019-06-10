require "rails_helper"

RSpec.describe User, type: :model do
  # full pattern
  it "is valid with name, email, and password" do
    user = User.new(
        name: "TestUser",
        email: "testuser@example.com",
        password: "Password",
        )
    expect(user).to be_valid
  end

  it "is valid with name, email, password, and password_confirmation" do
    user = User.new(
        name: "TestUser",
        email: "testuser@example.com",
        password: "Password",
        password_confirmation: "Password",
        )
    expect(user).to be_valid
  end

  # password
  it "is invalid without password" do
    user = User.new(password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  it "is invalid if password_confirmation doesn't match password" do
    user = User.new(
        name: "TestUser",
        email: "testuser@example.com",
        password: "Password",
        password_confirmation: "Buzzword",
       )
    expect(user).to_not be_valid
  end

  # name
  it "is valid with name which contains space" do
    user = User.new(
        name: "Test User",
        email: "testuser@example.com",
        password: "Password",
        )
    expect(user).to be_valid
  end

  it "is valid with name which contains symbol" do
    user = User.new(
        name: "User#01(*Test)",
        email: "testuser@example.com",
        password: "Password",
        )
    expect(user).to be_valid
  end

  it "is invalid without name" do
    user = User.new(name: nil)
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end

  # email
  it "is invalid without email" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "is valid with email which length is equal 255" do
    # 255 =           50 +  1  +       200 +    4
    email_str = "a" * 50 + "@" + "a" * 200 + ".com"
    user = User.new(
        name: "TestUser",
        email: email_str,
        password: "Password",
        )
    expect(user).to be_valid
  end

  it "is invalid with email which length is longer than 255" do
    # 256 =           51 +  1  +       200 +    4
    email_str = "a" * 51 + "@" + "a" * 200 + ".com"
    user = User.new(
        name: "TestUser",
        email: email_str,
        password: "Password",
        )
    expect(user).to_not be_valid
  end

  it "is invalid with email of wrong format" do
    user = User.new(email: "test user@example.com")
    user.valid?
    expect(user.errors[:email]).to include("は不正な値です")

    user = User.new(email: "test@user@example.com")
    user.valid?
    expect(user.errors[:email]).to include("は不正な値です")

    user = User.new(email: "testuser@example,com")
    user.valid?
    expect(user.errors[:email]).to include("は不正な値です")

    user = User.new(email: "testuser_example.com")
    user.valid?
    expect(user.errors[:email]).to include("は不正な値です")
  end

  it "is invalid with email which is already registered" do
    user_a = User.create(
        name: "UserA",
        email: "user-a@example.com",
        password: "Password",
        )
    user_b = User.new(
        name: "UserB",
        email: "user-a@example.com",
        password: "OtherPassword",
        )
    expect(user_b).to_not be_valid
  end

  # tasks
  it "returns tasks belong to it" do
    user = User.create(
        name: "TestUser",
        email: "testuser@example.com",
        password: "Password",
        )
    task = Task.create(
        subject: "TestTask",
        user_id: user.id,
    )
    expect(user.tasks).to include(task)
  end

end
