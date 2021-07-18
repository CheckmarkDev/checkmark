# frozen_string_literal: true

module Mutations
  class UpdateTask < BaseMutation
    null true

    argument :task_uuid, String, required: true
    argument :content, String, required: false
    argument :state, String, required: false
    argument :images, [ApolloUploadServer::Upload], required: false

    field :task, Types::TaskType, null: false
    field :errors, [String], null: false

    def ready?(**_args)
      raise GraphQL::ExecutionError, 'Authentication is required' if context[:current_user].nil?

      true
    end

    def resolve(task_uuid:, content: nil, state: nil, images: nil)
      task = Task.find_by(uuid: task_uuid)
      if content.present?
        task.content = content
      end
      if state.present?
        task.state = state
      end

      if !images.nil?
        task.images.each do |image|
          image.purge unless images.include?(image.uuid)
        end

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
