class User < ApplicationRecord
  has_secure_password

  enum :role, %i[ member librarian ].index_by(&:itself)

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 6 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
