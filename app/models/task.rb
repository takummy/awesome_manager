class Task < ApplicationRecord  
  validates :title, presence: true, length: {maximum: 50}
  validates :content, presence: true, length: {maximum: 300}
  validates :state, presence: true

  enum state: { waiting: 0, working: 1, completed: 2 }
  enum priority: { low: 0, medium: 1, high: 2 }

  scope :order_by_expired_at, ->(sort) { all.order(expired_at: :desc) if sort }
  scope :search_title, ->(title) { where('title LIKE?', "%#{title}%") if title }
  scope :search_state, ->(state) { where('state = ?', "#{state}") if state}

#メソッドパターン
  # private
  # def self.order_by_expired_at?(sort)
  #   if sort
  #     all.order(expired_at: :desc)
  #   else
  #     all.order(created_at: :desc)
  #   end
  # end

  # def self.search_title?(title)
  #   if title
  #     where("title LIKE?", "%#{title}%")
  #   end
  # end

  # def self.search_state?(state)
  #   if state
  #     where("state = ?","#{state}")
  #   end
  # end
end