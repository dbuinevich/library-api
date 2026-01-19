require "rails_helper"

RSpec.describe Reader, type: :model do
  describe 'associations' do
    it { should have_many(:borrow_histories) }
    it { should have_many(:books).through(:borrow_histories) }
  end

  describe 'validations' do
    subject { build(:reader) }

    it { should validate_presence_of(:card_number) }
    it { should validate_uniqueness_of(:card_number) }
    it { should allow_value('123456').for(:card_number) }
    it { should_not allow_value('12345').for(:card_number) }
    it { should_not allow_value('abcdef').for(:card_number) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    it { should validate_presence_of(:full_name) }
  end
end
