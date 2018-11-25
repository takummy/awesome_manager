require 'faker'

5.times do
  states = %w(waiting working completed)
  Task.create(
    title: Faker::Lorem.unique.word,
    content: Faker::Lorem.unique.sentence,
    expired_at: Faker::Time.between(Date.current, Date.current.ago(1.month)),
    state: :waiting
  )
end