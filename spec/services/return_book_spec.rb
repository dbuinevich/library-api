require "rails_helper"

RSpec.describe ReturnBook do
  include ActiveSupport::Testing::TimeHelpers

  let(:reader) { create(:reader) }
  let(:book) { create(:book, borrowed: true, reader: reader, borrowed_at: 2.days.ago) }
  let!(:borrow_history) { create(:borrow_history, book: book, reader: reader, borrowed_at: 2.days.ago) }

  subject(:service) { described_class.new(book: book) }

  describe '#call' do
    context 'when the book has an unreturned borrow history' do
      it 'updates the borrow history returned_at' do
        travel_to Time.current do
          service.call
          borrow_history.reload
          expect(borrow_history.returned_at).to eq(Time.current)
        end
      end

      it 'marks the book as returned' do
        travel_to Time.current do
          service.call
          book.reload
          expect(book.borrowed).to be false
          expect(book.borrowed_at).to be_nil
          expect(book.reader).to be_nil
        end
      end
    end

    context 'when the book has no unreturned borrow history' do
      before do
        borrow_history.update!(returned_at: 1.day.ago)
      end

      it 'does not change the book or borrow histories' do
        travel_to Time.current do
          expect { service.call }.not_to change { borrow_history.reload.returned_at }
          book.reload
          expect(book.borrowed).to eq(true)
          expect(book.borrowed_at).not_to be_nil
          expect(book.reader).to eq(reader)
        end
      end
    end
  end
end
