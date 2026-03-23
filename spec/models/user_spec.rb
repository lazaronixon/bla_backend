require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#borrowed_books_count" do
    it "returns the count of not returned borrowings" do
      expect(users(:member).borrowed_books_count).to eq(2)
    end

    it "returns zero when the user has no active borrowings" do
      expect(users(:librarian_two).borrowed_books_count).to eq(0)
    end
  end

  describe "#overdue_books_count" do
    it "returns the count of overdue borrowings" do
      expect(users(:bob).overdue_books_count).to eq(1)
    end

    it "returns zero when the user has no overdue borrowings" do
      expect(users(:member).overdue_books_count).to eq(0)
    end
  end
end
