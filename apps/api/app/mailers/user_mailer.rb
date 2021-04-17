class UserMailer < ApplicationMailer

  def welcome (user)
    @name = "#{user.first_name} #{user.last_name}"

    mail(to: user.email, subject: 'Bienvenue sur Checkmark.dev !') do |format|
      format.text
      format.mjml
    end
  end
end
