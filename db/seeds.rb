# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ha4gu = User.create(name: "ha4gu", email: "ha4gu@example.com", password: "P@ssw0rd")

COUNT = 50000 # should be less than or equal 99999
1.step(COUNT) do |i|
  current_subject = "Task#{sprintf "%05d", i}"
  Task.find_or_create_by!(subject: current_subject) do |t|
    t.subject = current_subject
    t.detail  = "This is Task #{sprintf "%05d", i}"
    t.deadline_date = Date.today.since(i.days).to_date if i % 3 == 0
    t.deadline_time = Time.zone.now.since(i.minutes)   if i % 5 == 0
    if i % 100 == 0
      t.status = 2
    elsif i % 10 == 0
      t.status = 1
    else
      t.status = 0
    end
    t.created_at = t.updated_at =  Time.zone.now.ago((10000-i).minutes)
  end
end
