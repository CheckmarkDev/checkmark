class Task < ApplicationRecord
  belongs_to :user
  has_many :task_likes
  has_many :task_comments

  enum state: [
    :todo,
    :doing,
    :done
  ]

end
