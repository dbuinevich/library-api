require "rails_helper"

RSpec.describe ReminderJob, type: :job do
  include ActiveJob::TestHelper

  let(:reader) { create(:reader) }
  let(:book) { create(:book) }

  let(:borrow_history) do
    create(:borrow_history,
           book: book,
           reader: reader,
           borrowed_at: 30.days.ago,
           returned_at: nil)
  end

  before do
    ActionMailer::Base.deliveries.clear
    ActionMailer::Base.delivery_method = :test
  end

  describe '#perform' do
    context 'when borrow history exists and book is not returned' do
      it 'sends a return reminder email' do
        perform_enqueued_jobs do
          described_class.perform_now(borrow_history.id, 3)
        end

        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to include(reader.email)
        expect(mail.subject).to match('Book return reminder (3 days left)')
      end
    end

    context 'when borrow history does not exist' do
      it 'does not send any email' do
        expect {
          described_class.perform_now(0, 3)
        }.not_to change { ActionMailer::Base.deliveries.count }
      end
    end

    context 'when book is already returned' do
      it 'does not send any email' do
        borrow_history.update(returned_at: Time.current)

        expect {
          described_class.perform_now(borrow_history.id, 3)
        }.not_to change { ActionMailer::Base.deliveries.count }
      end
    end
  end
end
