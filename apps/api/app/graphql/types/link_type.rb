# frozen_string_literal: true

module Types
  class LinkType < Types::BaseObject
    field :uuid, ID, null: false
    field :user, Types::UserType, null: false
    field :title, String, null: false
    field :url, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def user
      RecordLoader.for(User).load(object.user_id)
    end
  end
end
