# frozen_string_literal: true

module Mutations
  class CreateLink < BaseMutation
    null true

    argument :url, String, required: true

    field :link, Types::LinkType, null: false
    field :errors, [String], null: false

    def ready?(**_args)
      raise GraphQL::ExecutionError, 'Authentication is required' if context[:current_user].nil?

      true
    end

    def resolve(url:)
      link = context[:current_user].links.build(
        url: url
      )

      if link.save
        # Successful creation, return the created object with no errors
        {
          link: link,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          link: nil,
          errors: link.errors.full_messages
        }
      end
    end
  end
end
