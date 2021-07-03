# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    field :uuid, ID, null: false
    field :content, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :commentable_type, String, null: true
    field :commentable_id, Integer, null: true

    field :user, Types::UserType, null: false

    def user
      RecordLoader.for(User).load(object.user_id)
    end
  end
end
