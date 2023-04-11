# book_store

This is a simple command-line interface (CLI) application that displays a list of books with their title and author name. The list is stored in a PostgreSQL database called "book_store".

To use the application, run the app.rb file. This will connect to the "book_store" database and fetch all the books. The books will be displayed in the following format:

book_id - book_title - author_name

Each book has a unique id, a title, and an author name.

To display the books, the app uses the BookRepository class, which provides methods to interact with the database. The BookRepository class has a method called "all", which returns all the books in the database. The app then iterates through the books and displays them on the command-line.

To add new books or modify existing ones, you can modify the BookRepository class or add new classes to interact with the database.
