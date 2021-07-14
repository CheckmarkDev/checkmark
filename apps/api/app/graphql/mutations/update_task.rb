# frozen_string_literal: true

module Mutations
  class UpdateTask < BaseMutation
    null true

    argument :task_uuid, String, required: true
    argument :content, String, required: false
    argument :state, String, required: false

    field :task, Types::TaskType, null: false
    field :errors, [String], null: false

    def ready?(**_args)
      raise GraphQL::ExecutionError, 'Authentication is required' if context[:current_user].nil?

      true
    end

    def resolve(task_uuid:, content: nil, state: nil)
      task = Task.find_by(uuid: task_uuid)
      if content.present?
        task.content = content
      end
      if state.present?
        task.state = state
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
