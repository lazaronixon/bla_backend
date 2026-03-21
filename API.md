# BLA API

BLA is a library management API that allows members to browse and borrow books, and librarians to manage the catalog and track borrowings.

## Authentication

### Sign Up

Create a new account. New users are assigned the `member` role by default.

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"email_address": "user@example.com", "password": "secret123", "password_confirmation": "secret123"}' \
  http://localhost:3000/sign_up
```

__Response:__

```
HTTP/1.1 201 Created
```

```json
{
  "id": 1,
  "email_address": "user@example.com",
  "role": "member",
  "created_at": "2026-03-20T00:00:00.000Z",
  "updated_at": "2026-03-20T00:00:00.000Z"
}
```

__Error responses:__

| Status Code | Description |
|-------------|-------------|
| `422 Unprocessable Entity` | Validation failed (e.g. email taken, password too short, confirmation mismatch) |

### Sign In

Authenticate and receive a session token.

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"email_address": "user@example.com", "password": "secret123"}' \
  http://localhost:3000/sign_in
```

__Response:__

```
HTTP/1.1 201 Created
X-Session-Token: eyJfcmFpbHMi...
X-Session-Expires-In: 1209600
```

```json
{
  "id": 1,
  "email_address": "user@example.com",
  "role": "member",
  "created_at": "2026-03-20T00:00:00.000Z",
  "updated_at": "2026-03-20T00:00:00.000Z"
}
```

The session token is returned in the `X-Session-Token` response header. `X-Session-Expires-In` contains the token's lifetime in seconds.

__Error responses:__

| Status Code | Description |
|-------------|-------------|
| `401 Unauthorized` | Invalid email address or password |

### Using the Session Token

Include the token in the `Authorization` header on every authenticated request:

```bash
curl -H "Authorization: Bearer eyJfcmFpbHMi..." \
  -H "Accept: application/json" \
  http://localhost:3000/books
```

> [!IMPORTANT]
> __A session token is like a password, keep it secret and do not share it with anyone.__
> Tokens expire automatically. Re-authenticate to get a new one.

### Sign Out

```bash
curl -X DELETE \
  -H "Authorization: Bearer eyJfcmFpbHMi..." \
  http://localhost:3000/sign_out
```

__Response:__

Returns a plain text confirmation message. Tokens expire automatically — signing out signals intent to end the session on the client side.

## Error Responses

| Status Code | Description |
|-------------|-------------|
| `401 Unauthorized` | Missing or invalid session token |
| `403 Forbidden` | Valid token, but your role doesn't permit this action |
| `404 Not Found` | The requested resource doesn't exist |
| `422 Unprocessable Entity` | Validation failed (see response body for details) |

A `422` response may include details about which fields failed:

```json
{
  "errors": ["Title can't be blank", "Copies must be greater than 0"]
}
```

## Books

Books represent titles in the library catalog.

### `GET /books`

Returns a list of all books, ordered chronologically (oldest first). Accepts an optional search query.

__Query Parameters:__

| Parameter | Description |
|-----------|-------------|
| `q` | Search term — matches against title, author, and genre (case-insensitive) |

```bash
curl -H "Authorization: Bearer eyJfcmFpbHMi..." \
  "http://localhost:3000/books?q=tolkien"
```

__Response:__

```json
[
  {
    "id": 1,
    "title": "The Lord of the Rings",
    "author": "J.R.R. Tolkien",
    "genre": "Fantasy",
    "isbn": "9780261102354",
    "copies": 3,
    "created_at": "2026-01-01T10:00:00.000Z",
    "updated_at": "2026-01-01T10:00:00.000Z",
    "url": "http://localhost:3000/books/1.json",
    "borrowings_url": "http://localhost:3000/books/1/borrowings.json"
  }
]
```

### `GET /books/:id`

Returns a single book.

__Response:__

```json
{
  "id": 1,
  "title": "The Lord of the Rings",
  "author": "J.R.R. Tolkien",
  "genre": "Fantasy",
  "isbn": "9780261102354",
  "copies": 3,
  "created_at": "2026-01-01T10:00:00.000Z",
  "updated_at": "2026-01-01T10:00:00.000Z",
  "url": "http://localhost:3000/books/1.json",
  "borrowings_url": "http://localhost:3000/books/1/borrowings.json"
}
```

### `POST /books` _[librarian only]_

Creates a new book in the catalog.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `title` | string | Yes | The book title |
| `author` | string | Yes | The author's name |
| `genre` | string | Yes | The genre |
| `isbn` | string | Yes | The ISBN |
| `copies` | integer | Yes | Number of available copies (must be > 0) |

__Request:__

```json
{
  "book": {
    "title": "The Lord of the Rings",
    "author": "J.R.R. Tolkien",
    "genre": "Fantasy",
    "isbn": "9780261102354",
    "copies": 3
  }
}
```

__Response:__

```
HTTP/1.1 201 Created
```

Returns the created book object.

### `PATCH /books/:id` _[librarian only]_

Updates an existing book.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `title` | string | No | The book title |
| `author` | string | No | The author's name |
| `genre` | string | No | The genre |
| `isbn` | string | No | The ISBN |
| `copies` | integer | No | Number of available copies |

__Response:__

Returns the updated book object.

### `DELETE /books/:id` _[librarian only]_

Deletes a book and all its borrowing records.

__Response:__

Returns `204 No Content` on success.

## Borrowings

Borrowings track which members have checked out which books.

### `GET /books/:book_id/borrowings`

Returns all borrowings for a book, in reverse chronological order (most recent first).

__Response:__

```json
[
  {
    "id": 1,
    "due_at": "2026-04-03T23:59:59.000Z",
    "returned_at": null,
    "created_at": "2026-03-20T10:00:00.000Z",
    "updated_at": "2026-03-20T10:00:00.000Z",
    "user": {
      "id": 2,
      "email_address": "member@example.com",
      "role": "member",
      "created_at": "2026-01-01T00:00:00.000Z",
      "updated_at": "2026-01-01T00:00:00.000Z"
    },
    "book": {
      "id": 1,
      "title": "The Lord of the Rings",
      "author": "J.R.R. Tolkien",
      "genre": "Fantasy",
      "isbn": "9780261102354",
      "copies": 3,
      "created_at": "2026-01-01T10:00:00.000Z",
      "updated_at": "2026-01-01T10:00:00.000Z",
      "url": "http://localhost:3000/books/1.json",
      "borrowings_url": "http://localhost:3000/books/1/borrowings.json"
    },
    "url": "http://localhost:3000/books/1/borrowings/1.json"
  }
]
```

### `GET /books/:book_id/borrowings/:id`

Returns a single borrowing record.

__Response:__

Returns the borrowing object shown above.

### `POST /books/:book_id/borrowings` _[member only]_

Borrows a book. The due date is automatically set to **2 weeks** from the current date. The borrowing is attributed to the authenticated user.

__Validations:__
- The book must have at least one available copy.
- The member cannot borrow the same book twice concurrently.

__Response:__

```
HTTP/1.1 201 Created
```

Returns the created borrowing object.

__Error responses:__

| Status Code | Description |
|-------------|-------------|
| `422 Unprocessable Entity` | No copies available, or member already has this book borrowed |

### `PATCH /books/:book_id/borrowings/:id` _[librarian only]_

Marks a borrowing as returned. Sets `returned_at` to the current timestamp.

__Response:__

Returns the updated borrowing object.

### `DELETE /books/:book_id/borrowings/:id` _[librarian only]_

Deletes a borrowing record.

__Response:__

Returns `204 No Content` on success.

## My Profile

### `GET /my/user`

Returns the profile of the currently authenticated user.

```bash
curl -H "Authorization: Bearer eyJfcmFpbHMi..." \
  -H "Accept: application/json" \
  http://localhost:3000/my/user
```

__Response:__

```json
{
  "id": 1,
  "email_address": "user@example.com",
  "role": "member",
  "created_at": "2026-03-20T00:00:00.000Z",
  "updated_at": "2026-03-20T00:00:00.000Z"
}
```

## Dashboard

Dashboard endpoints provide summary views for librarians and members.

### `GET /books/total` _[librarian only]_

Returns library-wide statistics.

__Response:__

```json
{
  "total_books": 42,
  "total_borrowed": 15
}
```

`total_books` is the count of all books in the catalog. `total_borrowed` is the count of active (unreturned) borrowings.

### `GET /books/due_today` _[librarian only]_

Returns all active borrowings with a due date of today.

__Response:__

Returns an array of borrowing objects (same shape as `GET /books/:book_id/borrowings`).

### `GET /books/borrowed` _[member only]_

Returns all active borrowings for the authenticated member, in reverse chronological order.

__Response:__

Returns an array of borrowing objects (same shape as `GET /books/:book_id/borrowings`).

### `GET /members/with_overdue_books` _[librarian only]_

Returns all members who currently have at least one overdue borrowing.

__Response:__

```json
[
  {
    "id": 2,
    "email_address": "member@example.com",
    "role": "member",
    "created_at": "2026-01-01T00:00:00.000Z",
    "updated_at": "2026-01-01T00:00:00.000Z"
  }
]
```
