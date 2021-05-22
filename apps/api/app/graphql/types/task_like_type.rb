module Types
  class TaskLikeType < Types::BaseObject
    field :user, UserType, null: false
  end
end
