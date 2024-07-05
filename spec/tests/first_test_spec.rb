require 'rails_helper'

RSpec.feature 'Testing' do
  scenario 'Checking if everything works' do
    expect(true).to eq(true)
  end
end

# RSpec.describe Test, type: :model do
#   describe '#valid?' do
#     context 'presence' do
#       it do
#       end
#     end
#   end
# end
