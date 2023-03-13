FactoryBot.define do
  factory :tag_map do
    association :tag
    association :post
  end
end
