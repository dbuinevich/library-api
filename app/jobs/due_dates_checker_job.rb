class DueDatesCheckerJob < ApplicationJob
  queue_as :default

  def perform
    BorrowHistory.where(returned_at: nil).find_each do |history|
      due_date = history.borrowed_at + 30.days
      days_left = (due_date.to_date - Date.current).to_i

      next unless [3, 0].include?(days_left)

      ReminderJob.perform_later(history.id, days_left)
    end
  end
end
