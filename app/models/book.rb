class Book < ApplicationRecord
  scope :search, ->(query) { where("LOWER(title || ' ' || author || ' ' || genre) LIKE ?", "%#{query.downcase}%") }
end
