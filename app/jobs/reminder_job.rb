class ReminderJob < ApplicationJob
  queue_as :default

  def perform(borrow_history_id, days_left)
    borrow_history = BorrowHistory.find_by(id: borrow_history_id)

    return if borrow_history.nil? || borrow_history.returned_at.present?

    BookMailer.return_reminder(
      reader: borrow_history.reader,
      book: borrow_history.book,
      due_date: borrow_history.borrowed_at + 30.days,
      days_left: days_left
    ).deliver_now
  end
end
