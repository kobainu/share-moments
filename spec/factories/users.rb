FactoryBot.define do
  factory :user do
    sequence(:id)         { |n| n }
    name                  { "test" }
    sequence(:email)      { |n| "test_#{n}@example.com" }
    password              { "123456" }
    password_confirmation { "123456" }
  end
end
