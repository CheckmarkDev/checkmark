class Task < ApplicationRecord
  belongs_to :user
  has_many :task_likes

  enum state: [
    :todo,
    :doing,
    :done
  ]

end
