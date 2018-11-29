class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  
  before_validation {email.downcase!}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum:255 }, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password_digest, presence: true, length: { minimum: 6 }
  has_secure_password
end
