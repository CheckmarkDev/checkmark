class TaskGroupsController < ApplicationController

  api :GET, '/task_groups'
  def index
    @task_groups = TaskGroup.includes([
      user: [:streaks, avatar_attachment: :blob],
      tasks: [
        :projects,
        :task_comments,
        :task_likes,
        images_attachments: :blob
      ]
    ])
      .order(created_at: :desc)
      .page(params[:page])

    render "task_groups/index"
  end
end
