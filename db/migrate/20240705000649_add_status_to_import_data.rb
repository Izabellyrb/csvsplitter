class AddStatusToImportData < ActiveRecord::Migration[7.1]
  def change
    add_column :import_data, :status, :integer, default: 0
  end
end
