# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome(user)
    @name = user.full_name

    mail(to: user.email, subject: 'Bienvenue sur Checkmark.dev !') do |format|
      format.text
      format.mjml
    end
  end

  def email_validation(user, token)
    @name = user.full_name
    @token = token

    mail(to: user.email, subject: 'Validez votre adresse e-mail') do |format|
      format.text
      format.mjml
    end
  end
end
