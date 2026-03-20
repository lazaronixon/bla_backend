# BLA Backend

A library management API built with Ruby on Rails.

## Setup

Run the setup script to install dependencies, prepare the database, and load seed data from fixtures:

```bash
bin/setup
```

This will load demo data including books, borrowings, and the following users:

| Role | Email | Password |
|------|-------|----------|
| Librarian | librarian@example.com | password123 |
| Member | member@example.com | password123 |

## Running the server

```bash
bin/dev
```

## Running the test suite

```bash
bundle exec rspec
```
