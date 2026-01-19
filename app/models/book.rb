class Book < ApplicationRecord
  belongs_to :reader, optional: true
  has_many :borrow_histories

  validates :serial_number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 100_000, less_than_or_equal_to: 999_999 }
  validates :title, :author, presence: true
end
