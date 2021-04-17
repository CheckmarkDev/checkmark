module Types
  class TaskLikeType < Types::BaseObject
    field :uuid, String, null: false
    field :user, UserType, null: false
    field :task, TaskType, null: false
    field :state, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
