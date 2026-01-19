class ReturnBook
  def initialize(book:)
    @book = book
  end

  def call
    ActiveRecord::Base.transaction do
      return!
    end
  end

  private

  def return!
    borrow_history = @book.borrow_histories
                          .where(returned_at: nil)
                          .order(:borrowed_at)
                          .last

    return if borrow_history.nil?

    borrow_history.update!(returned_at: Time.current)

    @book.update!(
      borrowed: false,
      borrowed_at: nil,
      reader: nil
    )
  end
end
