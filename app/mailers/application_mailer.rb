class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV['MAIL_USER']}@gmail.com"
  layout 'mailer'
end
