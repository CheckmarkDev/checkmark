class User < ApplicationRecord
  has_secure_password

  has_many :tokens
  has_many :tasks
  has_many :task_likes
  has_many :task_comments

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :password, length: { minimum: 6 }

  before_save :format_username

  private
    def format_username
      self.username = self.username.parameterize
    end
end
