require 'faker'

Faker::Config.locale = :ja

states = %i(waiting working completed)
priorities = %i(low medium high)

User.create!(
  name: "owner",
  email: "owner@email.com",
  password: "password",
  admin: true
  )

50.times do 
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: "password"
    )
end

users = User.all

users.each do |user|
  10.times do
    user.tasks.create!(
      title: Faker::Lorem.word,
      content: Faker::Lorem.sentence,
      expired_at: Faker::Time.between(Date.current, Date.current.ago(1.month)),
      state: "#{states.sample}",
      priority: "#{priorities.sample}",
      )
  end
end

job = Label.create!(name: "仕事")
travel = Label.create!(name: "旅行")
personal = Label.create!(name: "プライベート")

tasks = Task.all

tasks.each_with_index do |task, i|
  task.labelings.create!(label_id: job.id) if i.even?
  task.labelings.create!(label_id: travel.id) if i.even?
  task.labelings.create!(label_id: personal.id) if i.odd?
end