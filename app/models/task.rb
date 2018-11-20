class Task < ApplicationRecord
  validates :title, presence: true, length: {maximum: 50}
  validates :content, presence: true, length: {maximum: 300}

  default_scope -> {order(created_at: :desc)}
end
