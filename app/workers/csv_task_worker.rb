class CsvTaskWorker
  include Sidekiq::Worker
  include CsvActions

  def perform(csv_file_path, email, imported_data)
    csv_download(csv_file_path)
    ImportDataService.save_imported_data(imported_data, email)

    csv_task = CsvTaskService.new("#{Rails.root.join("#{dynamic_path}.csv")}", email)
    csv_task.call

    ImportDataService.change_status(email)

    FileUtils.rm_rf(Rails.public_path.join('download'))
  end
end
