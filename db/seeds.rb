require 'faker'

states = %i(waiting working completed)
priorities = %i(low medium high)

50.times do
  Task.create(
    title: Faker::Lorem.unique.word,
    content: Faker::Lorem.unique.sentence,
    expired_at: Faker::Time.between(Date.current, Date.current.ago(1.month)),
    state: "#{states.sample}",
    priority: "#{priorities.sample}"
  )
end