module Types
  class LikeType < Types::BaseObject
    field :uuid, ID, null: false
    field :state, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :likeable_type, String, null: true
    field :likeable_id, Integer, null: true

    field :user, Types::UserType, null: false

    def user
      RecordLoader.for(User).load(object.user_id)
    end
  end
end
