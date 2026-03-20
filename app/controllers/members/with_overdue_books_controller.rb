class Members::WithOverdueBooksController < ApplicationController
  before_action :ensure_librarian

  def show
    @users = User.with_overdue_books.alphabetically
  end
end
