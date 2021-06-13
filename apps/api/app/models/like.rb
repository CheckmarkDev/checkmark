# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :task, touch: true, optional: true
  belongs_to :likeable, polymorphic: true

  after_commit :send_like_email, on: :create

  enum state: { active: 0, inactive: 1 }

  default_scope { where(state: Like.states[:active]) }

  scope :from_user, ->(user) { where(user: user) }

  private

  def send_like_email
    if task.present?
      notification = task.user.email_notification.like
      TaskMailer.like(task, user).deliver_later if notification
    end
  end
end
