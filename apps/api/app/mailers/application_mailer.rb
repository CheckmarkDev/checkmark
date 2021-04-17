class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@checkmark.dev'
  layout 'mailer'
end
