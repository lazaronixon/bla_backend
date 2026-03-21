require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  describe "validations on create" do
    describe "book_available" do
      it "is invalid when all copies are borrowed" do
        borrowing = Borrowing.new(user: users(:member_two), book: books(:pride_and_prejudice))
        expect(borrowing).to be_invalid
        expect(borrowing.errors[:book]).to include("is not available")
      end

      it "is valid when copies are available" do
        borrowing = Borrowing.new(user: users(:member_three), book: books(:dune))
        expect(borrowing).to be_valid
      end
    end

    describe "book_borrowed_multiple_times" do
      it "is invalid when the user already has an active borrowing for the book" do
        borrowing = Borrowing.new(user: users(:member), book: books(:dune))
        expect(borrowing).to be_invalid
        expect(borrowing.errors[:book]).to include("is already borrowed to you")
      end

      it "is valid when the user has no active borrowing for the book" do
        borrowing = Borrowing.new(user: users(:member_three), book: books(:dune))
        expect(borrowing).to be_valid
      end
    end
  end
end
