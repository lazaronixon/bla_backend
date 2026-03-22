class Books::TotalsController < ApplicationController
  before_action :ensure_librarian

  def show
    @total_books    = Book.sum(:copies)
    @total_borrowed = Borrowing.not_returned.count
  end
end
