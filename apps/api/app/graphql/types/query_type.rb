module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # field :all_users, [UserType], null: false

    # this method is invoked, when `all_link` fields is being resolved
    # def all_users
    #   User.all
    # end

    field :all_tasks, TaskType.connection_type, null: false
    field :all_task_groups, TaskGroupType.connection_type, null: false

    def all_tasks
      Task.all
    end

    def all_task_groups
      TaskGroup.includes(:tasks, :user).joins(:user, :tasks).order(created_at: :desc)
    end
  end
end
