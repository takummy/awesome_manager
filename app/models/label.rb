class Label < ApplicationRecord
  has_many :labelings, dependent: :destroy
  has_many :tasks, through: :labelings, source: :task, inverse_of: :labels

  validates :name, presence: true, length: { maximum: 40 }
end