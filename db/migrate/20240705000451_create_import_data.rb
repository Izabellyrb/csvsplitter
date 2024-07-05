class CreateImportData < ActiveRecord::Migration[7.1]
  def change
    create_table :import_data do |t|
      t.string  :file_name
      t.string  :user_email
      t.float   :file_size
      t.integer :rows
      t.integer :splits

      t.timestamps
    end
  end
end
