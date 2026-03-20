class BooksController < ApplicationController
  before_action :set_book, only: %i[ show update destroy ]
  before_action :ensure_permission_to_manage_books, only: %i[ create update destroy ]

  def index
    @books = params[:q].present? ? Book.search(params[:q]) : Book.all
  end

  def show
  end

  def create
    @book = Book.create!(book_params); render :show, status: :created
  end

  def update
    @book.update(book_params); render :show
  end

  def destroy
    @book.destroy!
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.expect(book: [ :title, :author, :genre, :isbn, :copies ])
    end

    def ensure_permission_to_manage_books
      head :forbidden unless Current.user.librarian?
    end
end
