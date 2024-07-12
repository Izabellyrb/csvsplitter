class Api::V1::TasksController < Api::V1::ApiController
  include CsvActions
  before_action :set_data, :check_csv, :check_email

  def import
    if @csv_task.is_complete?
      csv_file_path = csv_upload(params[:csv_file].tempfile.path)
      CsvTaskWorker.perform_async(csv_file_path, @email, imported_data)
      render json: { message: 'File received successfully! Please check your email in a few minutes.' },
             status: :ok
    else
      render json: { message: 'The uploaded file cannot be split as the content is incomplete/empty.' },
             status: :bad_request
    end
  end

  private

  def imported_data
    { file_name: params[:csv_file].original_filename, user_email: params[:email], file_size: File.size(params[:csv_file]),
      rows: @csv_task.csv_rows.length, splits: @csv_task.slices.length }
  end

  def set_data
    @csv_file = params[:csv_file]
    @email = params[:email]
    @csv_task = CsvTaskService.new(@csv_file, @email)
  end

  def check_csv
    return if @csv_file.present? && @csv_file.content_type == 'text/csv'

    render json: { message: 'Please insert a file in .csv format' }, status: :bad_request
  end

  def check_email
    return if @email.present? && @email =~ URI::MailTo::EMAIL_REGEXP

    render json: { message: 'Please enter a valid email to send the split files' }, status: :bad_request
  end
end
