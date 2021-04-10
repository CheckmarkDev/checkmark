class TaskLike < ApplicationRecord
  belongs_to :user
  belongs_to :task

  enum state: [
    :active,
    :inactive
  ]

  scope :from_user, -> (user) { where(user: user) }
end
