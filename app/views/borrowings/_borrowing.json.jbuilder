json.extract! borrowing, :id, :returned_at, :created_at, :updated_at
json.user { json.partial! "users/user", user: borrowing.user }
json.book { json.partial! "books/book", book: borrowing.book }
json.url book_borrowing_url(borrowing.book, borrowing, format: :json)
