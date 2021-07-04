# frozen_string_literal: true

module Types
  class TaskType < Types::BaseObject
    field :uuid, ID, null: false
    field :content, String, null: true
    field :state, String, null: false
    field :source, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :likes, Types::LikeType.connection_type, null: true
    field :comments, Types::CommentType.connection_type, null: true
    field :user, Types::UserType, null: false

    def user
      RecordLoader.for(User).load(object.user_id)
    end

    delegate :likes, to: :object
    delegate :comments, to: :object
  end
end
