require 'faker'

5.times do |i|
  Task.create(
    title: "テスト#{i+1}", 
    content: Faker::Lorem.unique.word
    )
end