class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV.fetch('MAIL_USER')}@gmail.com"
  layout 'mailer'
end
