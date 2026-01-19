class BookMailer < ApplicationMailer
  default from: "library@example.com"

  def return_reminder(reader:, book:, due_date:, days_left:)
    @reader = reader
    @book = book
    @due_date = due_date
    @days_left = days_left

    mail(
      to: reader.email,
      subject: days_left.zero? ?
                 "Book return due today" :
                 "Book return reminder (#{days_left} days left)"
    )
  end
end
