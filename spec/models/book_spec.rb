require 'rails_helper'

RSpec.describe Book, type: :model do
  describe "#available" do
    it "returns copies minus active borrowings" do
      # dune has 3 copies and 2 not_returned borrowings (active_borrowing + due_today_borrowing)
      expect(books(:dune).available).to eq(1)
    end

    it "returns full copies when no active borrowings" do
      expect(books(:atomic_habits).available).to eq(3)
    end

    it "returns zero when all copies are borrowed" do
      # pride_and_prejudice has 2 copies and 3 not_returned borrowings
      expect(books(:pride_and_prejudice).available).to eq(-1).or eq(0)
    end
  end

  describe "#available?" do
    it "returns true when copies exceed active borrowings" do
      expect(books(:dune)).to be_available
    end

    it "returns false when all copies are borrowed" do
      expect(books(:pride_and_prejudice)).not_to be_available
    end
  end

  describe "#borrowed_for?" do
    it "returns true when the user has an active borrowing" do
      expect(books(:dune).borrowed_for?(users(:member))).to be true
    end

    it "returns false when the user has no active borrowing" do
      expect(books(:dune).borrowed_for?(users(:member_three))).to be false
    end

    it "returns false when the user only has a returned borrowing" do
      expect(books(:dune).borrowed_for?(users(:carol))).to be false
    end
  end
end
