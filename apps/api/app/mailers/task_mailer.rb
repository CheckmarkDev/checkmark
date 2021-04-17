class TaskMailer < ApplicationMailer

  def like (task, user)
    @name = "#{user.first_name} #{user.last_name}"
    @username = user.username
    @task_content = task.content
    @task_username = task.user.username
    @task_uuid = task.uuid
    @task_state = task.state

    mail(to: task.user.email, subject: "#{user.username} a aimé votre tâche !") do |format|
      format.text
      format.mjml
    end
  end

  def comment (task, user, comment)
    @name = "#{user.first_name} #{user.last_name}"
    @username = user.username
    @task_content = task.content
    @task_username = task.user.username
    @task_uuid = task.uuid
    @task_state = task.state
    @comment_content = comment.content

    mail(to: task.user.email, subject: "#{user.username} a commenté votre tâche !") do |format|
      format.text
      format.mjml
    end
  end
end
