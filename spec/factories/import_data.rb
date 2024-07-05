FactoryBot.define do
  factory :import_data do
    file_name { Faker::File.file_name(ext: 'csv') }
    user_email { Faker::Internet.email }
    file_size { rand(5005...10005) }
    rows { rand(100...80000) }
    splits { rand(2...160) }
    created_at  { Faker::Time.between(from: DateTime.now - 15, to: DateTime.now) }
    status { 2 }
  end
end
