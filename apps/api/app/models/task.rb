class Task < ApplicationRecord
  belongs_to :user

  enum state: [
    :todo,
    :doing,
    :done
  ]

end
