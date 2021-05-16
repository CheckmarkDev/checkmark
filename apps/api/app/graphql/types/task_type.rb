module Types
  class ImageTaskType < Types::BaseObject
    field :url, String, null: false
    field :thumbnail_url, String, null: false

    def url
      Rails.application.routes.url_helpers.url_for(object)
    end

    def thumbnail_url
      Rails.application.routes.url_helpers.url_for(object.variant(resize_to_fit: [720, 720]))
    end
  end

  class TaskType < Types::BaseObject
    field :uuid, ID, null: false
    field :content, String, null: true
    field :state, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :task_group, TaskGroupType, null: false
    field :user, UserType, null: false
    field :streak, StreakType, null: false
    field :comments, [TaskCommentType], null: false
    field :likes, [UserType], null: false

    field :comments_count, Integer, null: false
    field :likes_count, Integer, null: false

    field :images, [ImageTaskType], null: false

    def comments
      object.task_comments
    end

    def comments_count
      object.task_comments.count
    end

    def likes
      object.task_likes
    end

    def likes_count
      object.task_likes.count
    end

    def images
      object.images
    end
  end
end
