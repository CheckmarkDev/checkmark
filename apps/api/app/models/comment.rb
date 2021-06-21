# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task, touch: true, optional: true
  belongs_to :commentable, polymorphic: true, optional: true

  after_commit :send_comment_email, on: :create

  validates :content, presence: true, length: { minimum: 2, maximum: 1000 }, profanity: true

  private

  def send_comment_email
    return unless commentable_type == 'Task'

    task = Task.find(commentable_id)

    # Do not send the e-mail if we're commenting our own task.
    return false if task.user == user

    notification = task.user.email_notification.comment
    TaskMailer.comment(task, user, self).deliver_later if notification
  end
end
