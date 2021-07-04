# frozen_string_literal: true

module Mutations
  class CreateComment < BaseMutation
    null true

    argument :task_uuid, String, required: true
    argument :content, String, required: true

    field :comment, Types::CommentType, null: false
    field :errors, [String], null: false

    def ready?(**_args)
      raise GraphQL::ExecutionError, 'Authentication is required' if context[:current_user].nil?

      true
    end

    def resolve(task_uuid:, content:)
      comment = Task.find_by(uuid: task_uuid).comments.build(
        user: context[:current_user],
        content: content
      )

      if comment.save
        # Successful creation, return the created object with no errors
        {
          comment: comment,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          comment: nil,
          errors: comment.errors.full_messages
        }
      end
    end
  end
end
