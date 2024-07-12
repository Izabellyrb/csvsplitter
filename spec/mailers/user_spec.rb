require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  include ActionDispatch::TestProcess::FixtureFile

  it 'sends an email' do
    email = 'teste@gmail.com'
    zip_files = fixture_file_upload('spec/fixtures/files/new_files.zip', 'application/zip')
    mail = described_class.splitted_csv(email, zip_files.read).deliver_now

    expect(mail.subject).to eq 'Here is your split file!'
    expect(mail.to).to include 'teste@gmail.com'
    expect(mail.attachments).to(include { filename = 'split_files.zip' })
  end
end
