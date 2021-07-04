module Types
  class TaskGroupType < Types::BaseObject
    field :uuid, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :user, Types::UserType, null: false
    field :tasks, [Types::TaskType], null: false

    def user
      RecordLoader.for(User).load(object.user_id)
    end

    delegate :tasks, to: :object
  end
end
