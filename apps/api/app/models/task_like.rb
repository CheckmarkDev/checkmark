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
      TaskMailer.like(self.task, self.user).deliver_later
    end
end
