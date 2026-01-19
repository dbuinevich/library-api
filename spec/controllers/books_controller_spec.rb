require "rails_helper"

RSpec.describe BooksController do
  let!(:reader) { create(:reader) }
  let!(:book) { create(:book) }

  describe '#index' do
    it 'returns all books with reader info if borrowed' do
      book.update(borrowed: true, reader: reader, borrowed_at: Time.current)

      get :index

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(1)
      expect(json.first['title']).to eq(book.title)
    end
  end

  describe "#show" do
    it 'returns book with borrow histories' do
      book.borrow_histories.create!(reader: reader, borrowed_at: Time.current)

      get :show, params: {id: book.id}

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(book.id)
      expect(json['borrow_histories'].first['reader']['full_name']).to eq(reader.full_name)
    end
  end

  describe '#create' do
    let(:valid_params) { { book: { serial_number: 123456, title: 'New Book', author: 'New Author' } } }

    it 'creates a new book' do
      expect {
        post :create, params: valid_params
      }.to change(Book, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['title']).to eq('New Book')
    end

    it 'returns errors with invalid params' do
      post :create, params: { book: { title: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe '#update_status' do
    context 'borrowing a book' do
      it 'updates book to borrowed and creates history' do
        put :update_status, params: { id: book.id, borrowed: true, reader_id: reader.id }

        expect(response).to have_http_status(:ok)
        book.reload
        expect(book.borrowed).to be(true)
        expect(book.reader).to eq(reader)
        expect(book.borrow_histories.last.reader).to eq(reader)
      end
    end

    context 'returning a book' do
      before do
        book.update(borrowed: true, reader: reader, borrowed_at: Time.current)
        book.borrow_histories.create!(reader: reader, borrowed_at: 1.day.ago)
      end

      it 'updates book to available and closes history' do
        put :update_status, params: { id: book.id }

        expect(response).to have_http_status(:ok)
        book.reload
        expect(book.borrowed).to be(false)
        expect(book.reader).to be_nil
        expect(book.borrow_histories.last.returned_at).not_to be_nil
      end
    end
  end

  describe '#destroy' do
    it 'deletes the book' do
      expect {
        delete :destroy, params: { id: book.id }
      }.to change(Book, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
