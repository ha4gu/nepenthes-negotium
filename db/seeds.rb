# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

COUNT = 20 # should be less than or equal 100
COUNT.times do |i|
  current_subject = "Task#{sprintf "%03d", i+1}"
  Task.find_or_create_by!(subject: current_subject) do |t|
    t.subject = current_subject
    t.detail  = "This is Task #{sprintf "%03d", i+1}"
    t.created_at = t.updated_at =  Time.zone.now.ago((100-i).hours).ago((100-i).minutes)
  end
end
