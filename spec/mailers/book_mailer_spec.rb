require "rails_helper"

RSpec.describe BookMailer, type: :mailer do
  describe '#return_reminder' do
    let(:reader) { create(:reader) }
    let(:book) { create(:book) }

    let(:borrowed_at) { Time.current }
    let(:due_date) { borrowed_at + 30.days }

    subject(:mail) do
      described_class.return_reminder(
        reader: reader,
        book: book,
        due_date: due_date,
        days_left: days_left
      )
    end

    context '3 days before due date' do
      let(:days_left) { 3 }

      it 'sets the correct subject' do
        expect(mail.subject).to eq('Book return reminder (3 days left)')
      end

      it 'sends to the reader email' do
        expect(mail.to).to eq([reader.email])
      end

      it 'sets the sender' do
        expect(mail.from).to eq(['library@example.com'])
      end

      it 'greets the reader by name' do
        expect(mail.body.encoded).to include(reader.full_name)
      end

      it 'includes book title and author' do
        expect(mail.body.encoded).to include(book.title)
        expect(mail.body.encoded).to include(book.author)
      end

      it 'mentions remaining days' do
        expect(mail.body.encoded).to include('3 days')
      end
    end

    context 'on the due date' do
      let(:days_left) { 0 }

      it 'uses the due-today subject' do
        expect(mail.subject).to eq('Book return due today')
      end

      it 'mentions that the book is due today' do
        expect(mail.body.encoded.downcase).to include('due today')
      end
    end
  end
end
