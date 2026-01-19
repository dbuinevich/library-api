FactoryBot.define do
  factory :book do
    sequence(:serial_number) { |n| 100000 + n }
    title { 'Amazing Book' }
    author { 'Nice Guy' }
    borrowed { false }
  end
end
