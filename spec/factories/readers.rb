FactoryBot.define do
  factory :reader do
    sequence(:card_number) { |n| 100000 + n }
    full_name { 'John Doe' }
    sequence(:email) { |n| "reader#{n}@example.com" }
  end
end
