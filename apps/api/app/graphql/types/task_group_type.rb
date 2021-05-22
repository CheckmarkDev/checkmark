module Types
  class TaskGroupType < Types::BaseObject
    field :uuid, ID, null: false
    field :user, UserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false

    field :tasks, [TaskType], null: false

    def user
      RecordLoader.for(User).load(object.user_id)
    end

    def tasks
      AssociationLoader.for(TaskGroup, :tasks).load(object)
    end
  end
end
