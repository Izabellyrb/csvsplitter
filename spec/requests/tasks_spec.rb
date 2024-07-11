require 'rails_helper'

describe 'csv import' do
  include ActionDispatch::TestProcess::FixtureFile

  let(:folder) { Rails.root.join(dynamic_path) }
  let(:json_data) { JSON.parse(response.body) }
  let(:user_email) {'email@test.com'}

  it 'POST csv file should return status ok' do
    uploaded_file = fixture_file_upload('customer_data_100.csv', 'text/csv')

    post '/api/v1/import', params: { csv_file: uploaded_file, email: user_email }

    expect(json_data['message']).to eq 'Arquivo recebido com sucesso! Aguarde a conversão no email.'
    expect(response.status).to eq 200
  end

  it 'POST invalid if there is no file' do

    post '/api/v1/import', params: { csv_file: nil, email: user_email }

    expect(json_data['message']).to eq 'Por favor, insira um arquivo no formato csv'
    expect(response.status).to eq 400
  end

  it 'POST invalid if the file is not in csv format' do
    uploaded_file = fixture_file_upload('spec/fixtures/files/customer_data.txt', 'text/plain')

    post '/api/v1/import', params: { csv_file: uploaded_file, email: user_email }

    expect(json_data['message']).to eq 'Por favor, insira um arquivo no formato csv'
    expect(response.status).to eq 400
  end

  it 'POST invalid if the file is not fully filled' do
    uploaded_file = fixture_file_upload('spec/fixtures/files/customer_missing_data.csv', 'text/csv')

    post '/api/v1/import', params: { csv_file: uploaded_file, email: user_email }

    expect(json_data['message']).to eq 'O arquivo enviado não pode ser dividido, pois o conteúdo está incompleto/vazio.'
    expect(response.status).to eq 400
  end

  it 'POST invalid if there is no email' do
    uploaded_file = fixture_file_upload('customer_data_100.csv', 'text/csv')

    post '/api/v1/import', params: { csv_file: uploaded_file, email: nil}

    expect(json_data['message']).to eq 'Por favor, insira um email válido para envio dos arquivos divididos'
    expect(response.status).to eq 400
  end
end
