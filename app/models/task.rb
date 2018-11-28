class Task < ApplicationRecord
  validates :title, presence: true, length: {maximum: 50}
  validates :content, presence: true, length: {maximum: 300}

  scope :created_at, -> {order(created_at: :desc)}
  scope :expired_at, -> {order(expired_at: :desc)}
end
