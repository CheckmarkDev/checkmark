class User < ApplicationRecord
  has_secure_password

  has_many :tokens
  has_many :tasks
  has_many :task_likes
  has_many :task_comments
  has_many :task_groups
  has_many :streaks

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :password, length: { minimum: 6 }

  before_save :format_username
  after_create :send_welcome

  def last_streak
    streaks.order(created_at: :desc).first
  end

  def streak
    streak = self.last_streak
    if streak.present?
      return (DateTime.now - streak.created_at.to_datetime).to_i
    end

    return 0
  end

  def send_welcome
    UserMailer.welcome(self).deliver_later
  end

  private
    def format_username
      self.username = self.username.parameterize
    end
end
