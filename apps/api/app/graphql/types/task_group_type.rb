module Types
  class TaskGroupType < Types::BaseObject
    field :uuid, ID, null: false
    field :user, UserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :tasks, [TaskType], null: false
  end
end
