# Library Management API
A simple Ruby on Rails API for managing a library’s books, readers, and borrow history. Designed for library staff to track books, their borrowing status, and send reminders for returning borrowed books.

## Installation
1. Clone the repository
```
git clone <your-repo-url>
cd <your-repo-folder>
```

2. Build and start Docker containers
 ```
docker compose build
docker compose up
```

3. Setup the database

Run migrations inside the Docker container:

    docker compose exec web rails db:create db:migrate

## Testing

The project uses RSpec for tests.

To run tests inside Docker:

    docker compose exec web bundle exec rspec

## API Endpoints

- GET	/books	List all books with borrow status and reader info
- GET	/books/:id	Retrieve a specific book with full borrow history
- POST	/books	Add a new book
- PATCH	/books/:id/update_status	Update book as borrowed or returned
- DELETE	/books/:id	Delete a book

## Key Design Decisions

### Service Objects:

BorrowBook and ReturnBook encapsulate business logic for borrowing and returning books.

Atomicity guaranteed with ActiveRecord::Base.transaction to prevent inconsistent state between Book and BorrowHistory.

### Reminder Emails:

Handled by ReminderJob using ActiveJob and scheduled DueDatesCheckerJob.

Uses letter_opener in development for previewing emails in the browser instead of sending real emails.

### Database Indexing:

borrowed_at and returned_at are indexed for faster queries on active borrowings.

## Limitations & Future Improvements

### Authentication & Authorization: 
Currently omitted for simplicity. Could add JWT-based or Devise-based auth.

### Email Delivery in Production: 
Currently uses letter_opener for preview; needs SMTP or SendGrid setup in production.

### Pagination: 
/books endpoint returns all records; could add pagination for performance.

### Validation Enhancements: 
Currently only basic validation; could add more sophisticated checks or constraints.

### Error Handling: 
Simple JSON errors; could standardize API error responses.

### Soft Delete:
Deleting now is complete; could be soft to store full records history
