# frozen_string_literal: true

class TaskGroupsController < ApplicationController
  api :GET, '/task_groups'
  def index
    @task_groups = TaskGroup.includes([
                                        user: [avatar_attachment: :blob],
                                        tasks: [
                                          :task_comments,
                                          :task_likes,
                                          { images_attachments: :blob,
                                            projects: [avatar_attachment: :blob],
                                            mentions: [avatar_attachment: :blob] }
                                        ]
                                      ])
                            .order(created_at: :desc)
                            .page(params[:page])

    render 'task_groups/index'
  end
end
