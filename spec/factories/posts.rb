FactoryBot.define do
  factory :post do
    title { "タイトル" }
    # photo {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixture/image.jpg'))}
    association :user
  end
end
