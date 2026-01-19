class BorrowBook
  BORROW_PERIOD = 30.days

  def initialize(book:, reader_id:)
    @book = book
    @reader = Reader.find(reader_id)
  end

  def call
    return if @book.borrowed?
    ActiveRecord::Base.transaction do
      borrow!
      schedule_reminders
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

  def schedule_reminders
    due_date = @borrow_history.borrowed_at + BORROW_PERIOD

    ReminderJob
      .set(wait_until: due_date - 3.days)
      .perform_later(@borrow_history.id, 3)

    ReminderJob
      .set(wait_until: due_date)
      .perform_later(@borrow_history.id, 0)
  end
end
