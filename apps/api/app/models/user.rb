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

  def full_name
    "#{first_name} #{last_name}"
  end

  def last_streak
    streaks.order(created_at: :desc).first
  end

  def streak
    streak = self.last_streak
    if streak.present?
      last_task = streak.tasks.select(:created_at).order(created_at: :desc).first
      return (last_task.created_at.to_datetime - streak.created_at.to_datetime.beginning_of_day).to_i
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
    User.all.each_with_index do |user, k|
      date_range = DateTime.now.last_week..DateTime.yesterday.at_midnight
      tasks = user.tasks.where(created_at: date_range).count

      todo = user.tasks.todo.where(created_at: date_range).count
      doing = user.tasks.doing.where(created_at: date_range).count
      done = user.tasks.done.where(created_at: date_range).count

      if tasks > 0
        Webhook.all.each do |webhook|
          data = ApplicationController.render(template: 'webhook_job/weekly_summary', assigns: {
            user: user,
            todo: todo,
            doing: doing,
            done: done
          })

          WebhookJob.set(wait: k * 30.seconds).perform_later(webhook, 'weekly_summary.created', data)
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
