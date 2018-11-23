class Task < ApplicationRecord
  validates :title, presence: true, length: {maximum: 50}
  validates :content, presence: true, length: {maximum: 300}

  scope :created_at, -> {order(created_at: :desc)}
  scope :expired_at, -> {order(expired_at: :desc)}

  enum state: { waiting: 0, working: 1, completed: 2 }

  private
  def self.order_by_expired_at?(sort)
    if sort
      all.expired_at
    else
      all.created_at  
    end
  end

  def self.search_title?(title)
    if title
      all.where("title LIKE?", "%#{title}%")
    end
  end
end