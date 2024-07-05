class ImportData < ApplicationRecord
  enum status: { waiting: 0, sent: 2 }

  validates :file_name, :user_email, :file_size, :rows, :splits, presence: true
  validates :file_size, :rows, :splits, numericality: { greater_than: 0 }
  validates :user_email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
