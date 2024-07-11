require 'rails_helper'

describe 'csv import' do
  include ActionDispatch::TestProcess::FixtureFile

  let(:folder) { Rails.root.join(dynamic_path) }
  let(:json_data) { JSON.parse(response.body) }
  let(:user_email) {'email@test.com'}

  it 'POST csv file should return status ok' do
    uploaded_file = fixture_file_upload('customer_data_100.csv', 'text/csv')

    post '/api/v1/import', params: { csv_file: uploaded_file, email: user_email }

    expect(json_data['message']).to eq 'File received successfully! Please wait for the conversion in the specified email.'
    expect(response.status).to eq 200
  end

  it 'POST invalid if there is no file' do

    post '/api/v1/import', params: { csv_file: nil, email: user_email }

    expect(json_data['message']).to eq 'Please insert a file in .csv format'
    expect(response.status).to eq 400
  end

  it 'POST invalid if the file is not in csv format' do
    uploaded_file = fixture_file_upload('spec/fixtures/files/customer_data.txt', 'text/plain')

    post '/api/v1/import', params: { csv_file: uploaded_file, email: user_email }

    expect(json_data['message']).to eq 'Please insert a file in .csv format'
    expect(response.status).to eq 400
  end

  it 'POST invalid if the file is not fully filled' do
    uploaded_file = fixture_file_upload('spec/fixtures/files/customer_missing_data.csv', 'text/csv')

    post '/api/v1/import', params: { csv_file: uploaded_file, email: user_email }

    expect(json_data['message']).to eq 'The uploaded file cannot be split as the content is incomplete/empty.'
    expect(response.status).to eq 400
  end

  it 'POST invalid if there is no email' do
    uploaded_file = fixture_file_upload('customer_data_100.csv', 'text/csv')

    post '/api/v1/import', params: { csv_file: uploaded_file, email: nil}

    expect(json_data['message']).to eq 'Please enter a valid email to send the split files'
    expect(response.status).to eq 400
  end
end
