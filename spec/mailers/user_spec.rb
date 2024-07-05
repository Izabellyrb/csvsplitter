require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  include ActionDispatch::TestProcess::FixtureFile

  it 'sends an email' do
    email = 'teste@gmail.com'
    zip_files = fixture_file_upload('spec/fixtures/files/new_files.zip', 'application/zip')
    mail = described_class.splitted_csv(email, zip_files.read).deliver_now

    expect(mail.subject).to eq 'Aqui está o seu arquivo dividido!'
    expect(mail.to).to include 'teste@gmail.com'
    expect(mail.attachments).to include {filename = "arquivos_divididos.zip"}
  end
end
