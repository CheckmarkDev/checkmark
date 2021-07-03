# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :all_links, Types::LinkType.connection_type, null: false, description: 'Return all links'
    field :random_users, [Types::UserType], null: false, description: 'Return 10 random users'
    field :all_comments, Types::CommentType.connection_type, null: false, description: 'Return all comments for a task' do
      argument :task_uuid, String, required: true
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

    def all_comments (task_uuid:)
      Task.find_by(uuid: task_uuid).comments
    end
  end
end
