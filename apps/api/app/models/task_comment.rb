class TaskComment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  after_create :send_comment_email

  private
    def send_comment_email
      notification = self.task.user.email_notification.comment
      if notification
        TaskMailer.comment(self.task, self.user, self).deliver_later
      end
    end
end
