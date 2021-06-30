# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :uuid, ID, null: false
    field :email, String, null: false
    field :username, String, null: false
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :timezone, String, null: true
    field :status, Integer, null: false
    field :description, String, null: true

    field :avatar_url, String, null: false
    field :streak, Integer, null: false

    delegate :avatar_url, to: :object
    delegate :streak, to: :object
  end
end
