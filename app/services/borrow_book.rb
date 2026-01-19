class BorrowBook
  def initialize(book:, reader_id:)
    @book = book
    @reader = Reader.find(reader_id)
  end

  def call
    return if @book.borrowed?

    ActiveRecord::Base.transaction do
      borrow!
    end
  end

  private

  def borrow!
    @book.update!(
      borrowed: true,
      borrowed_at: Time.current,
      reader: @reader
    )

    @borrow_history = BorrowHistory.create!(
      book: @book,
      reader: @reader,
      borrowed_at: @book.borrowed_at
    )
  end
end
