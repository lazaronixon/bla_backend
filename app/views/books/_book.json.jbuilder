json.extract! book, :id, :title, :author, :genre, :isbn, :copies, :available, :created_at, :updated_at
json.url book_url(book, format: :json)
json.borrowings_url book_borrowings_url(book, format: :json)
