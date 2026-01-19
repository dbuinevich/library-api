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
- PUT	/books/:id/update_status	Update book as borrowed or returned
- DELETE	/books/:id	Delete a book
