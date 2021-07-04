# frozen_string_literal: true

module Types
  class ProjectType < Types::BaseObject
    field :uuid, ID, null: false
    field :slug, String, null: false
    field :name, String, null: true
    field :description, String, null: true
    field :url, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :main_color, String, null: false

    field :user, Types::UserType, null: false

    field :avatar_url, String, null: false

    def user
      RecordLoader.for(User).load(object.user_id)
    end

    delegate :avatar_url, to: :object
  end
end
