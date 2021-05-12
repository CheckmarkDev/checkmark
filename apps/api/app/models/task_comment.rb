# frozen_string_literal: true

class TaskComment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  after_create :send_comment_email

  private

  def send_comment_email
    # Do not send the e-mail if we're commenting our own task.
    return false if task.user == user

    notification = task.user.email_notification.comment
    TaskMailer.comment(task, user, self).deliver_later if notification
  end
end
