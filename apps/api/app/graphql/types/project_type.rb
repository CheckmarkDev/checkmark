module Types
  class ProjectType < Types::BaseObject
    field :uuid, ID, null: false
    field :slug, String, null: true
    field :name, String, null: false
    field :description, String, null: true
    field :url, String, null: true
    field :avatar_url, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :user, UserType, null: false
    field :tasks, [TaskType], null: false

    def avatar_url
      object.avatar_url
    end
  end
end
