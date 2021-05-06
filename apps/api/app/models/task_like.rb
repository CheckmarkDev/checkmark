class TaskLike < ApplicationRecord
  belongs_to :user
  belongs_to :task

  after_create :send_like_email

  enum state: [
    :active,
    :inactive
  ]

  scope :from_user, -> (user) { where(user: user) }

  private
    def send_like_email
      notification = self.task.user.email_notification.like
      if notification
        TaskMailer.like(self.task, self.user).deliver_later
      end
    end
end
