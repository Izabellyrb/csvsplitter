class UserMailer < ApplicationMailer
  def splitted_csv(email, file)
    @email = email
    attachments['split_files.zip'] = file

    attachments.inline['csvsplitter-logo.png'] = {
      data: File.read(Rails.root.join('app/assets/images/csvsplitter-logo.png')),
      mime_type: 'image/png'
    }

    mail(to: @email, subject: 'Here is your split file!')
  end
end
