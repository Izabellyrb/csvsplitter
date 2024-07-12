require 'rails_helper'
require 'csv'

describe 'csv split' do
  include CsvActions

  let(:download_folder) { Dir.mkdir('public/download') }
  let(:folder) { Rails.root.join(dynamic_path) }
  let(:file) { file_fixture('customer_data_100.csv') }
  let(:email) { 'example@email.com' }

  it 'splits file in smaller parts' do
    download_folder

    CsvTaskService.new(file, email).call

    expect(folder.empty?).to eq false
    expect(folder.join('customer_data1.csv').exist?).to eq true
    expect(folder.join('customer_data2.csv').exist?).to eq true
    expect(CSV.read(folder.join('customer_data1.csv'))).to include ['149', 'Chickie', 'Grayce',
                                                                    'Chickie.Grayce@blamail.com', '545']
    expect(CSV.read(folder.join('customer_data2.csv'))).to include ['150', 'Evita', 'Douglass',
                                                                    'Evita.Douglass@blamail.com', '742']
    expect(folder.join('customer_data3.csv').exist?).to eq false
  end

  it 'the files are splitted evenly' do
    download_folder

    CsvTaskService.new(file, email).call

    expect(CSV.read(folder.join('customer_data1.csv')).length - 1).to eq 50
    expect(CSV.read(folder.join('customer_data2.csv')).length - 1).to eq 50
  end
end
