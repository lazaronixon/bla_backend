class User < ApplicationRecord
  has_secure_password

  has_many :borrowings

  scope :alphabetically,     -> { order :email_address }
  scope :with_overdue_books, -> { where borrowings: Borrowing.overdue }

  enum :role, %i[ member librarian ].index_by(&:itself)

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 6 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def borrowed_books_count
    borrowings.not_returned.count
  end

  def overdue_books_count
    borrowings.overdue.count
  end
end
