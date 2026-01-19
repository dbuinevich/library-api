require "rails_helper"

RSpec.describe Book, type: :model do
  describe 'associations' do
    it { should belong_to(:reader).optional }
    it { should have_many(:borrow_histories) }
  end

  describe 'validations' do
    subject { build(:book) }

    it { should validate_presence_of(:serial_number) }
    it { should validate_uniqueness_of(:serial_number) }
    it { should validate_numericality_of(:serial_number).only_integer }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
  end
end
