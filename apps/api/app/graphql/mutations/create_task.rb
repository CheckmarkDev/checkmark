module Mutations
  class CreateTask < BaseMutation
    type Types::TaskType

    argument :content, String, required: true

    def resolve (content: nil)
      puts "ok?", content
      # Task.create!(
      #   content: content,
      #   state: state,
      #   user: user
      # )
    end
  end
end
