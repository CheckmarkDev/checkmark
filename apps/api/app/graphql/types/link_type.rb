module Types
  class LinkType < Types::BaseObject
    field :uuid, ID, null: false
    field :user, Types::UserType, null: false
    field :title, String, null: false
    field :description, String, null: true
    field :url, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
