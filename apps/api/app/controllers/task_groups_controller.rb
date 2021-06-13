# frozen_string_literal: true

class TaskGroupsController < ApplicationController
  api :GET, '/task_groups'
  def index
    @task_groups = TaskGroup
      .includes([
        user: [avatar_attachment: :blob],
        tasks: [
          :comments,
          :likes,
          { images_attachments: :blob,
            projects: [avatar_attachment: :blob],
            mentions: [avatar_attachment: :blob] }
        ]
      ])
      .where(user: {
               status: User.statuses[:validated]
             })
      .order(created_at: :desc)

    @task_groups = @task_groups.where(tasks: { state: params[:state] }) if params[:state].present?

    @task_groups = @task_groups
      .page(params[:page])

    render 'task_groups/index'
  end
end
