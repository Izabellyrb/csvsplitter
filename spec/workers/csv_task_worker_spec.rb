require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe CsvTaskWorker, type: :worker do
  include CsvActions

  let(:file_path) { file_fixture('customer_data_100.csv') }
  let(:email) { 'example@email.com' }
  let(:worker) { double('worker_methods') }
  let(:imported_data) { {"file_name"=>"customer_data_100.csv", "user_email"=>"example@email.com", "file_size"=>5005, "rows"=>100, "splits"=>2, "status"=> "false" } }

  it 'enqueues a job' do
    described_class.perform_async(file_path, email, imported_data)

    expect(described_class.jobs.size).to eq(1)
  end

  it 'access the worker properly' do
    allow(CsvTaskService).to receive(:new).and_return(worker)
    allow(ImportDataService).to receive(:save_imported_data)
    allow(ImportDataService).to receive(:change_status)
    allow(worker).to receive(:call)
    allow_any_instance_of(CsvTaskService).to receive(:csv_upload).and_call_original

    described_class.new.perform(csv_upload(file_path), email, imported_data)

    expect(ImportDataService).to have_received(:save_imported_data).with(imported_data, email)
    expect(ImportDataService).to have_received(:change_status).with(email)
    expect(worker).to have_received(:call)
  end
end
