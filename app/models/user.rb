class User < ApplicationRecord
  has_secure_password
  enum :role, %i[ member librarian ].index_by(&:itself)
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
