class Borrowing < ApplicationRecord
  belongs_to :user, default: -> { Current.user }
  belongs_to :book

  scope :reverse_chronologically, -> { order created_at: :desc, id: :desc }
  scope :chronologically,         -> { order created_at: :asc,  id: :asc  }

  scope :not_returned, -> { where returned_at: nil }
  scope :due_today,    -> { not_returned.where due_at: Time.current.all_day }
  scope :overdue,      -> { not_returned.where due_at: ..Time.current }

  before_create { self.due_at = 2.weeks.from_now.end_of_day }

  validate :book_available, on: :create
  validate :book_borrowed_multiple_times, on: :create

  private
    def book_available
      errors.add(:book, :unavailable, message: "is not available") unless book.available?
    end

    def book_borrowed_multiple_times
      errors.add(:book, :borrowed, message: "is already borrowed to you") if book.borrowed_for?(user)
    end
end
