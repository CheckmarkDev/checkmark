# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :update_task, mutation: Mutations::UpdateTask
    field :create_task, mutation: Mutations::CreateTask
    field :create_like, mutation: Mutations::CreateLike
    field :create_comment, mutation: Mutations::CreateComment
    field :create_link, mutation: Mutations::CreateLink
  end
end
