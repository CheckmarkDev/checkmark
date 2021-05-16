# frozen_string_literal: true

class TaskLike < ApplicationRecord
  belongs_to :user
  belongs_to :task

  after_commit :send_like_email, on: :create

  enum state: { active: 0, inactive: 1 }

  default_scope { where(state: TaskLike.states[:active]) }

  scope :from_user, ->(user) { where(user: user) }

  private

  def send_like_email
    notification = task.user.email_notification.like
    TaskMailer.like(task, user).deliver_later if notification
  end
end
