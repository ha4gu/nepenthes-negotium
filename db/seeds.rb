# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create(name: "Admin", email: "admin@example.com", password: "asdf", admin: true)
ha4gu = User.create(name: "ha4gu", email: "ha4gu@example.com", password: "asdf", admin: false)
test1 = User.create(name: "test1", email: "test1@example.com", password: "asdf", admin: false)
test2 = User.create(name: "test2", email: "test2@example.com", password: "asdf", admin: false)
test3 = User.create(name: "test3", email: "test3@example.com", password: "asdf", admin: false)

COUNT = 5000 # should be less than or equal 99999
1.step(COUNT) do |i|
  current_subject = "Task#{sprintf "%05d", i}"
  Task.find_or_create_by!(subject: current_subject) do |t|
    t.subject = current_subject
    t.detail  = "This is Task #{sprintf "%05d", i}"
    t.deadline_date = Time.zone.today.since(i.days).to_date if i % 3 == 0
    t.deadline_time = Time.zone.now.since(i.minutes)   if i % 5 == 0

    # status
    if i % 100 == 0
      t.status = 2
    elsif i % 10 == 0
      t.status = 1
    else
      t.status = 0
    end

    # priority
    t.priority = \
      case i % 3
      when 0 then 2
      when 1 then 3
      else        4
      end

    # user
    t.user = case i % 9
             when 1 then test1
             when 2 then test2
             when 3 then test3
             when 4 || 5 then ha4gu
             else        admin
             end

    t.created_at = t.updated_at =  Time.zone.now.ago((10000-i).minutes)
  end
end
