require 'digest/md5'

class User < ApplicationRecord
  has_secure_password

  has_many :tokens
  has_many :tasks
  has_many :task_likes
  has_many :task_comments
  has_many :task_groups
  has_many :streaks
  has_one :email_notification

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :password, length: { minimum: 6 }

  before_create :create_email_notification
  before_save :format_username
  after_create :send_welcome

  def last_streak
    streaks.order(created_at: :desc).first
  end

  def streak
    streak = self.last_streak
    if streak.present?
      return (DateTime.now - streak.created_at.to_datetime.beginning_of_day).to_i
    end

    return 0
  end

  def avatar_url
    email_address = self.email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    image_src = "https://www.gravatar.com/avatar/#{hash}"

    image_src
  end

  def send_welcome
    UserMailer.welcome(self).deliver_later
  end

  def self.notify_weekly_summary
    User.all.each do |user|
      # Last week, monday morning
      task_groups = user.task_groups.where(created_at: DateTime.now.last_week..DateTime.yesterday.at_midnight)
      if task_groups.count > 0
        Webhook.all.each do |webhook|
          data = ApplicationController.render(template: 'webhook_job/weekly_summary', assigns: {
            user: user,
            task_groups: task_groups
          })

          WebhookJob.perform_now(webhook, 'weekly_summary', data)
        end
      end
    end
  end

  private
    def create_email_notification
      self.email_notification = EmailNotification.new
    end

    def format_username
      self.username = self.username.parameterize
    end
end
