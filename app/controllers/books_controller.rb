class BooksController < ApplicationController
  before_action :set_book, only: %i[ show update destroy ]
  before_action :ensure_librarian, only: %i[ create update destroy ]

  def index
    if params[:q].present?
      @books = Book.chronologically.search(params[:q])
    else
      @books = Book.chronologically
    end
  end

  def show
  end

  def create
    @book = Book.create!(book_params); render(:show, status: :created)
  end

  def update
    @book.update!(book_params); render(:show)
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
end
