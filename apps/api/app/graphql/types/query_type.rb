# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :user, Types::UserType, null: true do
      argument :uuid, String, required: true
    end

    field :task, Types::TaskType, null: true do
      argument :uuid, String, required: true
    end

    field :all_task_groups, Types::TaskGroupType.connection_type, null: false
    field :all_user_task_groups, Types::TaskGroupType.connection_type, null: false do
      argument :username, String, required: true
      argument :state, String, required: false
    end
    field :all_project_task_groups, Types::TaskGroupType.connection_type, null: false do
      argument :slug, String, required: true
      argument :state, String, required: false
    end
    field :all_links, Types::LinkType.connection_type, null: false, description: 'Return all links'
    field :random_users, [Types::UserType], null: false, description: 'Return 10 random users'
    field :all_comments, Types::CommentType.connection_type, null: false,
                                                             description: 'Return all comments for a task' do
      argument :task_uuid, String, required: true
    end

    field :all_likes, Types::LikeType.connection_type, null: false, description: 'Return all likes for a task' do
      argument :task_uuid, String, required: true
    end

    def task(uuid:)
      Task.find_by(uuid: uuid)
    end

    def user(uuid:)
      User.find_by(uuid: uuid)
    end

    def all_links
      Link.order(created_at: :desc)
    end

    def random_users
      users = Rails.cache.fetch('random_users', expires_in: 24.hours) do
        data = User
          .where.not(status: User.statuses[:blocked])
          .includes([avatar_attachment: :blob])
          .order('RANDOM()').limit(10)
          .pluck(:id)

        data
      end

      User.includes([avatar_attachment: :blob]).find(users)
    end

    def all_comments(task_uuid:)
      Task.find_by(uuid: task_uuid).comments.order(created_at: :desc)
    end

    def all_likes(task_uuid:)
      Task.find_by(uuid: task_uuid).likes.order(created_at: :desc)
    end

    def all_task_groups
      TaskGroup
        .includes([:user])
        .where(user: {
                 status: User.statuses[:validated]
               })
        .order(created_at: :desc)
    end

    def all_user_task_groups(username:, state:)
      task_groups = TaskGroup
        .includes(%i[user tasks])
        .where(user: {
                 status: User.statuses[:validated],
                 username: username
               })

      task_groups = task_groups.where(tasks: { state: state }) if state.present?

      task_groups.order(created_at: :desc)
    end

    def all_project_task_groups(slug:, state:)
      task_groups = TaskGroup
        .includes([:user])
        .where(user: {
                 status: User.statuses[:validated]
               })
        .joins(tasks: :projects)
        .where(projects: { slug: slug })

      task_groups = task_groups.where(tasks: { state: state }) if state.present?

      task_groups.order(created_at: :desc)
    end
  end
end
