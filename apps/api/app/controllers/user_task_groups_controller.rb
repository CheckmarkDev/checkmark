class UserTaskGroupsController < ApplicationController
  before_action :set_user, only: [:index]
  before_action :set_task_group, only: [:show]

  api :GET, '/users/:username/task_groups'
  def index
    @task_groups = TaskGroup.includes([
      user: [avatar_attachment: :blob],
      tasks: [
        :task_comments,
        :task_likes,
        images_attachments: :blob,
        projects: [avatar_attachment: :blob],
        mentions: [avatar_attachment: :blob],
      ]
    ])
      .where(user_id: @user.id)
      .order(created_at: :desc)
      .page(params[:page])

    render "task_groups/index"
  end

  private
    def set_user
      @user = User.find_by_username!(params[:id])
    end
end
