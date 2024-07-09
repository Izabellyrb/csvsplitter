class UserMailer < ApplicationMailer
  def splitted_csv(email, file)
    @email = email
    attachments['arquivos_divididos.zip'] = file

    attachments.inline['csvsplitter-logo.png'] = {
      data: File.read(Rails.root.join('app', 'assets', 'images', 'csvsplitter-logo.png')),
      mime_type: 'image/png'
    }

    mail(to: @email, subject: 'Aqui está o seu arquivo dividido!')
  end
end
