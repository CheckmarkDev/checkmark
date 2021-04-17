class UserMailer < ApplicationMailer

  def welcome
    mail(to: 'test@test.fr', subject: 'hello') do |format|
      format.text
      format.mjml
    end
  end
end
