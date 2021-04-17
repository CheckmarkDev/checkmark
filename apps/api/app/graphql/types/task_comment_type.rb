module Types
  class TaskCommentType < Types::BaseObject
    field :id, ID, null: false
    field :uuid, Types::UuidType, null: false
    field :user_id, Integer, null: false
    field :task_id, Integer, null: false
    field :content, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
