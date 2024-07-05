class ImportDataService
  def self.save_imported_data(imported_data, email)
    data = ImportData.new(
      file_name: imported_data["file_name"], user_email: email,
      file_size: imported_data["file_size"], rows: imported_data["rows"],
      splits: imported_data["splits"]
    )
    data.save! if data.valid?
  end

  def self.change_status(email)
    current_request = ImportData.where(user_email: email).last
    current_request.sent!
  end
end
