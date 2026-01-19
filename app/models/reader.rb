class Reader < ApplicationRecord
  has_many :borrow_histories
  has_many :books, through: :borrow_histories

  validates :card_number, presence: true, uniqueness: true, numericality: { only_integer: true }, length: { is: 6 }
  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
end
