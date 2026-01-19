require "rails_helper"

RSpec.describe BorrowHistory, type: :model do
  describe 'associations' do
    it { should belong_to(:book) }
    it { should belong_to(:reader) }
  end

  describe 'validations' do
    it { should validate_presence_of(:borrowed_at) }
  end
end
