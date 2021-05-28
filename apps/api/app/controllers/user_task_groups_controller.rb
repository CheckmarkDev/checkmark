# frozen_string_literal: true

class UserTaskGroupsController < ApplicationController
  before_action :set_user, only: [:index]

  api :GET, '/users/:username/task_groups'
  def index
    @task_groups = TaskGroup
      .includes([
        user: [avatar_attachment: :blob],
        tasks: [
          :task_comments,
          :task_likes,
          { images_attachments: :blob,
            projects: [avatar_attachment: :blob],
            mentions: [avatar_attachment: :blob] }
        ]
      ])
      .where(user: {
               id: @user.id,
               status: User.statuses[:validated]
             })
      .order(created_at: :desc)

    @task_groups = @task_groups.where(tasks: { state: params[:state] }) if params[:state].present?

    @task_groups = @task_groups
      .page(params[:page])

    render 'task_groups/index'
  end

  private

  def set_user
    @user = User.find_by!(username: params[:id])
  end
end
