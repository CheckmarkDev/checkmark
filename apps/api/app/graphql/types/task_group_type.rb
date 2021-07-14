module Types
  class TaskGroupType < Types::BaseObject
    field :uuid, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :user, Types::UserType, null: false
    field :tasks, [Types::TaskType], null: false do
      argument :state, String, required: false
    end

    def user
      RecordLoader.for(User).load(object.user_id)
    end

    def tasks(state: nil)
      tasks = object.tasks
      if state.present?
        tasks = tasks.where(state: state)
      end

      tasks
    end
  end
end
