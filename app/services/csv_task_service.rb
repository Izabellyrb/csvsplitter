require 'csv'
require 'zip'
require 'fileutils'

class CsvTaskService
  include CsvActions

  attr_reader :csv_file, :rows

  def initialize(csv_file, email)
    @csv_file = csv_file
    @email = email
  end

  def call
    create_dir
    split
    zip_folder
    send_email
  end

  def is_complete?
    return false if csv_rows.empty?
    csv_rows.each do |row|
      row.each do |item|
        return false if item.include?(nil)
      end
    end
  end

  def csv_rows
    @rows = []

    CSV.foreach(csv_file, headers: true) do |row|
      rows << row
    end

    rows
  end

  def slices
    csv_rows.each_slice(50).to_a
  end

  private

  def split
    slices.each_with_index do |slice, index|
      CSV.open(("#{dynamic_path}/customer_data#{ index + 1 }.csv"), 'wb') do |new_csv|
        new_csv << rows.first.headers
        slice.each do |row|
          new_csv << row
        end
      end
    end
  end

  def create_dir
    Dir.mkdir(dynamic_path) unless Dir.exist?(dynamic_path)
  end

  def zip_folder
    filenames = Dir.children(dynamic_path)
    zipfolder_name = "#{dynamic_path}.zip"

    unless File.exist?(zipfolder_name)
      Zip::File.open(zipfolder_name, create: true) do |zipfile|
        filenames.each do |filename|
          zipfile.add(filename, File.join(dynamic_path, filename))
        end
      end
    end
  end

  def send_email
    finding_zip = File.open("#{dynamic_path}.zip").read
    UserMailer.splitted_csv(@email, finding_zip).deliver_now
  end
end
