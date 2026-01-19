class Reader < ApplicationRecord
  has_many :borrow_histories, dependent: :destroy
  has_many :books, through: :borrow_histories

  validates :card_number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 100_000, less_than_or_equal_to: 999_999 }
  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
end
