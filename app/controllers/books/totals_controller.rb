class Books::TotalsController < ApplicationController
  before_action :ensure_librarian

  def show
    @total_books    = Book.count
    @total_borrowed = Borrowing.active.count
  end
end
