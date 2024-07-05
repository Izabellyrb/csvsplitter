require 'rails_helper'

RSpec.describe ImportData, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'not valid when attributes are empty' do
        import_data = ImportData.new()

        import_data.valid?

        expect(import_data.errors.messages.keys).to include :file_name, :user_email, :file_size, :rows, :splits
      end
    end

    context 'numericality' do
      it 'not valid if attribute values are less than or equal to 0' do
        import_data = ImportData.new(
          file_name: 'customer_data.csv', user_email: 'example@test.com', file_size: 0, rows: 0, splits: 0
        )

        import_data.valid?
        expect(import_data.errors.full_messages[0]).to eq 'Tamanho do arquivo (bytes) deve ser maior que 0'
        expect(import_data.errors.full_messages[1]).to eq 'Tamanho do arquivo (linhas) deve ser maior que 0'
        expect(import_data.errors.full_messages[2]).to eq 'Total de arquivos gerados deve ser maior que 0'
      end
    end

    context 'format' do
      it 'not valid if email has wrong format' do
        import_data = ImportData.new(
          file_name: 'customer_data.csv', user_email: 'example', file_size: 50, rows: 50, splits: 1
        )

        import_data.valid?

        expect(import_data.errors.messages.keys).to include :user_email
        expect(import_data.errors.messages[:user_email]).to eq ['não é válido']
      end
    end
  end
end
