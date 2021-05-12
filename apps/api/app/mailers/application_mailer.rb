# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Checkmark.dev <no-reply@checkmark.dev>'
  layout 'mailer'
end
