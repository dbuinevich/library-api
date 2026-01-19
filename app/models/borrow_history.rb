class BorrowHistory < ApplicationRecord
  belongs_to :book
  belongs_to :reader
  validates :borrowed_at, presence: true
end
