module CsvActions
  def csv_upload(file_path)
    response = `curl --upload-file #{file_path} https://oshi.at/customfilename/60`

    match = response.match(/https:\/\/oshi\.at\/\w+\s\[Download\]/)

    match ? match[0].gsub(' [Download]', '') : nil
  end

  def csv_download(csv_upload)
    Dir.mkdir("public/download") unless Dir.exist?("public/download")
    `curl -L #{csv_upload} > #{Rails.root.join("#{dynamic_path}.csv")}`
  end

  def dynamic_path
    @path ||= "public/download/new_files_#{Time.zone.now.strftime("%m-%d-%Y--%H.%M.%S")}"
  end
end
