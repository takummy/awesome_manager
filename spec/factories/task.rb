FactoryBot.define do
  factory :task do
    title { "Amazon定期便" }
    content { "来週から停止" }
    expired_at { "#{Date.current.since(1.month)}" }
    state { 0 }
  end
end