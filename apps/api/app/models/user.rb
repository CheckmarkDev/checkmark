class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  has_many :tokens
  has_many :tasks
  has_many :task_likes
  has_many :task_comments
  has_many :task_groups
  has_many :streaks
  has_many :projects
  has_one :email_notification
  has_and_belongs_to_many :mentions, class_name: "Task", join_table: "task_mentions"

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true, length: { minimum: 2 }
  # validates :password, length: { minimum: 6 }

  before_create :create_email_notification
  before_save :format_username
  after_create :send_welcome

  def last_streak
    streaks.joins(:tasks).order(created_at: :desc).first
  end

  def streak
    streak = ActiveRecord::Base.connection.select_values(
      ActiveRecord::Base::sanitize_sql_for_conditions(["
        select
          case t.created_at::timestamp <= timestamp 'yesterday'
            when true then 0
            when false then date_part('day', t.created_at::timestamp - s.created_at::timestamp) + 1
          end as streak
        from tasks as t inner join streaks as s on s.id = t.streak_id where s.id = (
          select streaks.id from streaks inner join tasks on tasks.streak_id = streaks.id where streaks.user_id = ? order by streaks.created_at desc limit 1
        ) order by t.created_at desc limit 1
      ", id])
    )

    if streak.nil? || streak[0].nil?
      return 0
    end

    return streak[0].to_int
  end

  def avatar_url
    if self.avatar.attached?
      return Rails.application.routes.url_helpers.url_for(self.avatar.variant(resize_to_fill: [100, 100]))
    end

    return ActionController::Base.helpers.image_url('default-avatar.png')
  end

  def send_welcome
    UserMailer.welcome(self).deliver_later
  end

  # For every user that has a current streak
  def self.notify_streak_reminder
    User.all.each do |user|
      if user.streak > 0
        today_tasks = user.tasks.where(created_at: DateTime.now.beginning_of_day...DateTime.now.end_of_day)
        if today_tasks.count === 0
          TaskMailer.streak_reminder(user).deliver_later
        end
      end
    end
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
