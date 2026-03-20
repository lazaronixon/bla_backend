class Books::DueTodaysController < ApplicationController
  before_action :ensure_librarian

  def show
    @borrowings = Borrowing.due_today
  end
end
