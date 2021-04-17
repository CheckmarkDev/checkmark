module Types
  class TaskType < Types::BaseObject
    field :uuid, String, null: false
    field :content, String, null: true
    field :state, Integer, null: false
    field :user, UserType, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :task_group, TaskGroupType, null: false
    field :streak, StreakType, null: true
  end
end
