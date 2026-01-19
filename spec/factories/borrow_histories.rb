FactoryBot.define do
  factory :borrow_history do
    book
    reader
    borrowed_at { Time.current }
    returned_at { nil }
  end
end
