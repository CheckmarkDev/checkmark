# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  has_many :tokens, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :task_likes, dependent: :destroy
  has_many :task_comments, dependent: :destroy
  has_many :task_groups, dependent: :destroy
  has_many :streaks, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_one :email_notification, dependent: :destroy
  has_and_belongs_to_many :mentions, class_name: 'Task', join_table: 'task_mentions'

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true, length: { minimum: 2 }
  # validates :password, length: { minimum: 6 }

  before_create :create_email_notification
  before_save :format_username
  after_commit :send_welcome, on: :create

  def full_name
    "#{first_name} #{last_name}"
  end

  def last_streak
    streaks.joins(:tasks).order(created_at: :desc).first
  end

  def streak
    # rubocop:disable Layout/LineLength
    streak = ActiveRecord::Base.connection.select_values(
      ActiveRecord::Base.sanitize_sql_for_conditions(["
        select
          case t.created_at::timestamp AT TIME ZONE :timezone <= timestamp 'yesterday'
            when true then 0
            when false then date_part('day', t.created_at::timestamp AT TIME ZONE :timezone - s.created_at::timestamp AT TIME ZONE :timezone) + 1
          end as streak
        from tasks as t inner join streaks as s on s.id = t.streak_id where s.id = (
          select streaks.id from streaks inner join tasks on tasks.streak_id = streaks.id where streaks.user_id = :user_id order by streaks.created_at desc limit 1
        ) order by t.created_at desc limit 1
      ", { user_id: id, timezone: timezone }])
    )
    # rubocop:enable Layout/LineLength

    return 0 if streak.nil? || streak[0].nil?

    streak[0].to_int
  end

  def avatar_url
    return Rails.application.routes.url_helpers.url_for(avatar.variant(resize_to_fill: [100, 100])) if avatar.attached?

    ActionController::Base.helpers.image_url('default-avatar.png')
  end

  def send_welcome
    UserMailer.welcome(self).deliver_later
  end

  # For every user that has a current streak
  def self.notify_streak_reminder
    User.all.find_each do |user|
      next unless user.streak.positive?

      timezone = user.timezone
      # rubocop:disable Layout/LineLength
      today_tasks = user.tasks.where(created_at: DateTime.now.in_time_zone(timezone).beginning_of_day...DateTime.now.in_time_zone(timezone).end_of_day)
      # rubocop:enable Layout/LineLength
      TaskMailer.streak_reminder(user).deliver_later if today_tasks.count.zero?
    end
  end

  def self.notify_weekly_summary
    User.all.each_with_index do |user, k|
      timezone = user.timezone
      date_range = DateTime.now.in_time_zone(timezone).last_week..DateTime.yesterday.in_time_zone(timezone).at_midnight
      tasks = user.tasks.where(created_at: date_range).count

      todo = user.tasks.todo.where(created_at: date_range).count
      doing = user.tasks.doing.where(created_at: date_range).count
      done = user.tasks.done.where(created_at: date_range).count

      next unless tasks.positive?

      Webhook.all.find_each do |webhook|
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

  private

  def create_email_notification
    self.email_notification = EmailNotification.new
  end

  def format_username
    self.username = username.parameterize
  end
end
