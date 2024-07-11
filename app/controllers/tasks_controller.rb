class TasksController < ApplicationController
  include CsvActions
  before_action :set_data, :check_csv, :check_email

  def import
    if @csv_task.is_complete?
      csv_file_path = csv_upload(params[:csv_file].tempfile.path)
      CsvTaskWorker.perform_async(csv_file_path, @email, imported_data)
      flash[:notice] = 'Arquivo recebido com sucesso! Aguarde a conversão no email.'
    else
      flash[:alert] = 'O arquivo enviado não pode ser dividido, pois o conteúdo está incompleto/vazio.'
    end
    redirect_to import_path
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
    unless @csv_file.present? && @csv_file.content_type == 'text/csv'
      flash[:alert] = 'Por favor, insira um arquivo no formato csv'
    end
  end

  def check_email
    unless @email.present? && @email =~ URI::MailTo::EMAIL_REGEXP
      flash[:alert] = 'Por favor, insira um email válido para envio dos arquivos divididos'
      redirect_to import_path
    end
  end
end
