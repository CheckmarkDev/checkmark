# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :task_group, optional: true
  belongs_to :streak, optional: true

  has_many :task_likes, dependent: :destroy
  has_many :task_comments, dependent: :destroy
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :mentions, class_name: 'User', join_table: 'task_mentions'
  has_many_attached :images

  enum state: { todo: 0, doing: 1, done: 2 }

  default_scope { order(created_at: :desc) }

  before_create :assign_projects
  before_update :assign_projects, if: :content_changed?
  before_create :assign_mentions
  before_update :assign_mentions, if: :content_changed?
  before_create :assign_task_group, if: proc { |task| task.task_group.nil? }
  before_create :assign_streak, if: proc { |task| task.streak.nil? }
  after_commit :notify_webhooks, on: :create
  after_commit :delete_remaining_task_group, on: :destroy
  after_commit :delete_remaining_streak, on: :destroy

  def assign_mentions
    self.mentions = []
    matches = content.scan(/@(\w*)/)

    matches.each do |match|
      user = User.find_by(username: match)
      mentions << user if user.present? && !mentions.exists?(user.id)
    end
  end

  def assign_projects
    self.projects = []
    matches = content.scan(/#(\w*)/)

    matches.each do |match|
      project = Project.find_by(slug: match)
      projects << project if project.present? && !projects.exists?(project.id)
    end
  end

  def assign_task_group
    timezone = user.timezone
    task_group = user.task_groups
                     .find_by(created_at: DateTime.now.in_time_zone(timezone)
      .beginning_of_day..DateTime.now.in_time_zone(timezone).end_of_day)

    if task_group.nil?
      task_group = TaskGroup.new
      task_group.user = user
      task_group.save!
    end

    self.task_group = task_group
  end

  def assign_streak
    last_streak = user.last_streak
    if last_streak.nil?
      last_streak = Streak.new
      last_streak.user = user
      last_streak.save!
    end

    last_task = last_streak.tasks.order(created_at: :desc).first
    timezone = user.timezone

    # rubocop:disable Layout/LineLength
    if last_task.present? && last_task.created_at.in_time_zone(timezone).to_datetime.beginning_of_day < DateTime.yesterday.in_time_zone(timezone)
      last_streak = Streak.new
      last_streak.user = user
      last_streak.save!
    end
    # rubocop:enable Layout/LineLength

    self.streak = last_streak
  end

  # Delete the associated task group if the task
  # we are deleting is the last one associated to that task group.
  def delete_remaining_task_group
    task_group.destroy! if task_group.present? && task_group.tasks.count.zero?
  end

  # Delete the associated task group if the task
  # we are deleting is the last one associated to that task group.
  def delete_remaining_streak
    streak.destroy! if streak.present? && streak.tasks.count.zero?
  end

  private

  def notify_webhooks
    Webhook.all.find_each do |webhook|
      data = ApplicationController.render(template: 'webhook_job/task_created', assigns: {
                                            task: self
                                          })

      WebhookJob.perform_later(webhook, 'task.created', data)
    end
  end
end
