# frozen_string_literal: true

module Types
  class TaskType < Types::BaseObject
    field :uuid, ID, null: false
    field :content, String, null: true
    field :state, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :source, Integer, null: false

    field :likes, Types::LikeType.connection_type, null: true

    delegate :likes, to: :object
  end
end
