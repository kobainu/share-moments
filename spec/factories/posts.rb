FactoryBot.define do
  factory :post do
    title { "タイトル" }
    association :user
  end
end
