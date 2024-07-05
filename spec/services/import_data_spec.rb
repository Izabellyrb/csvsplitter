require 'rails_helper'

RSpec.describe ImportDataService do
  let(:email) { 'example@email.com' }
  let(:imported_data) { {"file_name"=>"customer_data_100.csv", "user_email"=>"example@email.com", "file_size"=>5005, "rows"=>100, "splits"=>2, "status"=> 0 } }

  it 'saves the imported data' do
    ImportDataService.save_imported_data(imported_data, email)
    saved_data = ImportData.find_by(user_email: email)

    expect(saved_data).not_to be_nil
    expect(saved_data.file_name).to eq("customer_data_100.csv")
    expect(saved_data.status).to eq('waiting')
  end

  it 'changes the status when finished' do
    ImportDataService.save_imported_data(imported_data, email)
    ImportDataService.change_status(email)
    saved_data = ImportData.find_by(user_email: email)

    expect(saved_data).not_to be_nil
    expect(saved_data.status).to eq('sent')
  end
end
