# frozen_string_literal: true

module Mutations
  class CreateTask < BaseMutation
    null true

    argument :content, String, required: true
    argument :state, String, required: true
    argument :images, [ApolloUploadServer::Upload], required: false

    field :task, Types::TaskType, null: false
    field :errors, [String], null: false

    def ready?(**_args)
      raise GraphQL::ExecutionError, 'Authentication is required' if context[:current_user].nil?

      true
    end

    def resolve(content:, state:, images: nil)
      task = Task.new(
        user: context[:current_user],
        state: state,
        source: Task.sources[:checkmark],
        content: content
      )

      if images.present?
        images.each do |image|
          image_infos = image.as_json
          task.images.attach(
            io: image.to_io,
            filename: image_infos['original_filename'],
            content_type: image_infos['content_type']
          ) unless image.is_a? String
        end
      end

      if task.save
        # Successful creation, return the created object with no errors
        {
          task: task,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          task: nil,
          errors: task.errors.full_messages
        }
      end
    end
  end
end
