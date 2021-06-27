# frozen_string_literal: true

module Mutations
  class CreateLink < Mutations::BaseMutation
    null true

    argument :title, String, required: true
    argument :description, String, required: true
    argument :url, String, required: true

    field :link, Types::LinkType, null: false
    field :errors, [String], null: false

    def ready?(**args)
      if context[:current_user].nil?
        raise GraphQL::ExecutionError, "Authentication is required"
      end

      return true
    end

    def resolve(title:, description:, url:)
      link = context[:current_user].links.build(
        title: title,
        description: description,
        url: url
      )

      if link.save
        # Successful creation, return the created object with no errors
        {
          link: link,
          errors: [],
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
