module Types
  class UserType < Types::BaseObject
    field :uuid, String, null: false
    field :email, String, null: false
    field :username, String, null: false
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :timezone, String, null: true

    field :streak, Integer, null: false
    field :avatar_url, String, null: false

    def streak
      object.streak
    end

    def avatar_url
      object.avatar_url
    end
  end
end
