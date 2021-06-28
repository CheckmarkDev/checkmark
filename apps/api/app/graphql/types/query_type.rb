# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :all_links, [Types::LinkType], null: false, description: 'Return all links'
    field :random_users, [Types::UserType], null: false, description: 'Return 10 random users'

    def all_links
      Link.order(created_at: :desc).all
    end

    def random_users
      Rails.cache.fetch('random_users', expires_in: 24.hours) do
        return User.where.not(status: User.statuses[:blocked])
          .includes([avatar_attachment: :blob])
          .order('RANDOM()')
          .limit(10)
      end
    end
  end
end
