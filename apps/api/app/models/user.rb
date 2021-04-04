class User < ApplicationRecord
  has_secure_password

  has_many :tokens
  has_many :tasks

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }
end
