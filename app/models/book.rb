class Book < ApplicationRecord
  has_many :borrowings, dependent: :destroy

  validates :copies, numericality: { greater_than: 0 }

  scope :reverse_chronologically, -> { order created_at: :desc, id: :desc }
  scope :chronologically,         -> { order created_at: :asc,  id: :asc  }
  scope :search, ->(query) { where("LOWER(title || ' ' || author || ' ' || genre) LIKE ?", "%#{query.downcase}%") }

  def available?
    copies > borrowings.active.count
  end

  def borrowed_for?(user)
    borrowings.active.where(user:).exists?
  end
end
