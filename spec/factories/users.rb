FactoryBot.define do
  factory :user do
    sequence(:id)      { |n| n }
    name                  { "test" }
    # email                 { "test@example.com" }
    sequence(:email)      { |n| "test_#{n}@example.com" }
    password              { "123456" }
    password_confirmation { "123456" }
  end
end
