require "rails_helper"

RSpec.describe BorrowBook do
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers

  let(:reader) { create(:reader) }
  let(:book) { create(:book, borrowed: false) }

  subject(:service) { described_class.new(book: book, reader_id: reader.id) }

  describe '#call' do
    context 'when the book is available' do
      it 'marks the book as borrowed' do
        travel_to Time.current do
          service.call
          book.reload
          expect(book.borrowed).to be true
          expect(book.reader).to eq(reader)
          expect(book.borrowed_at).not_to be_nil
        end
      end

      it 'creates a borrow history record' do
        expect { service.call }.to change { BorrowHistory.count }.by(1)
        borrow_history = BorrowHistory.last
        expect(borrow_history.book).to eq(book)
        expect(borrow_history.reader).to eq(reader)
        expect(borrow_history.borrowed_at).to eq(book.borrowed_at)
      end

      it 'schedules reminder jobs at correct times' do
        travel_to Time.current do
          service.call
          borrow_history = BorrowHistory.last

          expect(enqueued_jobs.size).to eq(2)

          reminder_3_days = enqueued_jobs.find { |job| job[:args] == [borrow_history.id, 3] }
          reminder_0_days = enqueued_jobs.find { |job| job[:args] == [borrow_history.id, 0] }

          expect(reminder_3_days).not_to be_nil
          expect(reminder_0_days).not_to be_nil

          due_date = borrow_history.borrowed_at + 30.days
          expect(reminder_3_days[:at]).to eq((due_date - 3.days).to_f)
          expect(reminder_0_days[:at]).to eq(due_date.to_f)
        end
      end
    end

    context 'when the book is already borrowed' do
      before { book.update!(borrowed: true, reader: reader, borrowed_at: Time.current) }

      it 'does nothing' do
        expect { service.call }.not_to change { BorrowHistory.count }
        expect(enqueued_jobs.size).to eq(0)
      end
    end
  end
end
