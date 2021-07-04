module Mutations
  class CreateLike < BaseMutation
    null true

    argument :task_uuid, String, required: true

    field :like, Types::LikeType, null: false
    field :errors, [String], null: false

    def ready?(**_args)
      raise GraphQL::ExecutionError, 'Authentication is required' if context[:current_user].nil?

      true
    end

    def resolve(task_uuid:)
      task = Task.find_by(uuid: task_uuid)
      like = task.likes.where(
        user: context[:current_user]
      ).first

      if like.present?
        if like.active?
          like.state = Like.states[:inactive]
        else
          like.state = Like.states[:active]
        end
      else
        if task.user == context[:current_user]
          raise GraphQL::ExecutionError, 'Not allowed to like your own task.'
        end

        like = task.likes.build(
          user: context[:current_user],
          state: Like.states[:active]
        )
      end

      if like.save
        # Successful creation, return the created object with no errors
        Rails.cache.write([task, :likes], task.user_likes)

        {
          like: like,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          like: nil,
          errors: like.errors.full_messages
        }
      end
    end
  end
end
