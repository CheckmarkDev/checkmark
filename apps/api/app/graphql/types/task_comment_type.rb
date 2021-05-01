module Types
  class TaskCommentType < Types::BaseObject
    field :uuid, ID, null: false
    field :user, UserType, null: false
    field :task, TaskType, null: false
    field :content, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
