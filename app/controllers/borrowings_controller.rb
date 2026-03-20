class BorrowingsController < ApplicationController
  before_action :set_book
  before_action :set_borrowing, only: %i[ show update ]
  before_action :ensure_permission_to_borrow_book, only: %i[ create ]
  before_action :ensure_permission_to_return_book, only: %i[ update ]

  def index
    @borrowings = @book.borrowings.reverse_chronologically
  end

  def show
  end

  def create
    @borrowing = @book.borrowings.build

    if @borrowing.save
      render(:show, status: :created)
    else
      render json: @borrowing.errors, status: :unprocessable_content
    end
  end

  def update
    @borrowing.touch :returned_at; render(:show)
  end

  private
    def set_book
      @book = Book.find(params[:book_id])
    end

    def set_borrowing
      @borrowing = @book.borrowings.find(params[:id])
    end

    def ensure_permission_to_borrow_book
      head :forbidden unless Current.user.member?
    end

    def ensure_permission_to_return_book
      head :forbidden unless Current.user.librarian?
    end
end
