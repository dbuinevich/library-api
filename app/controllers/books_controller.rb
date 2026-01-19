class BooksController < ApplicationController
  before_action :set_book, only: [:show, :destroy, :update_status]

  def index
    render json: Book.all
  end

  def show
    render json: @book.as_json(include: { borrow_histories: { include: :reader } })
  end

  def create
    book = Book.new(book_params)
    if book.save
      render json: book, status: :created
    else
      render json: book.errors, status: :unprocessable_entity
    end
  end

  def update_status
    if params[:borrowed] == 'true'
      BorrowBook.new(
        book: @book,
        reader_id: params[:reader_id]
      ).call
    else
      ReturnBook.new(book: @book).call
    end

    render json: @book
  end

  def destroy
    @book.destroy
    head :no_content
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:serial_number, :title, :author)
  end
end
