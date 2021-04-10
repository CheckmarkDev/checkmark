class TaskLike < ApplicationRecord
  belongs_to :user
  belongs_to :task

  enum state: [
    :active,
    :inactive
  ]
end
