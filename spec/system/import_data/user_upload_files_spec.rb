require 'rails_helper'

describe 'User uploads a csv file' do
  it 'successfully' do

    visit root_path
    fill_in :email, with: 'example@test.com'
    attach_file :csv_file, Rails.root.join('spec/fixtures/files/customer_data_100.csv')
    click_on 'Split CSV'

    expect(page).to have_content 'CSV File Splitter'
    expect(page).to have_field :email
    expect(page).to have_field :csv_file
  end
end
