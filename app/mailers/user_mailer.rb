class UserMailer < ApplicationMailer
  default from: 'emailteste@gmail.com'

  def splitted_csv(email, file)
    @email = email
    attachments['arquivos_divididos.zip'] = file

    mail(to: @email, subject: 'Aqui está o seu arquivo dividido!')
  end
end
