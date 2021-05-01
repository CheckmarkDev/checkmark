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

    field :task, TaskType, null: true do
      argument :uuid, ID, required: true
    end
    field :all_tasks, TaskType.connection_type, null: false
    field :all_task_groups, TaskGroupType.connection_type, null: false
    field :user, UserType, null: false do
      argument :username, String, required: true
    end
    field :all_comments, [TaskCommentType, null: true], null: true do
      argument :task_uuid, ID, required: true
    end

    def user (username:)
      User.find_by_username!(username)
    end

    def task (uuid:)
      Task.find_by_uuid!(uuid)
    end

    def all_tasks
      Task.all
    end

    def all_comments (task_uuid:)
      Task.find_by_uuid!(task_uuid).task_comments
    end

    def all_task_groups
      TaskGroup.includes(:tasks, :user).joins(:user, :tasks).order(created_at: :desc)
    end
  end
end
