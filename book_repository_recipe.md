# BookStore Model and Repository Classes Design Recipe

```
         ┌────────────────┐  ┌─────────────────┐ ┌────────────────────────────┐   ┌────────────────────────────────┐ ┌────────────────────┐
         │  Terminal      │  │  Main program   │ │ BookRepository class       │   │ DatabaseConnection class       │ │ Postgres database  │
         │                │  │  (app.rb)       │ │ (in lib/book_repository.rb)│   │ (in lib/database_connection.rb)│ │                    │
         │                │  │                 │ │                            │   │                                │ │                    │
         └────────┬───────┘  └─────────┬───────┘ └─────────────┬──────────────┘   └──────────────────┬─────────────┘ └──────────┬─────────┘
                  │                    │                       │                                     │                          │
┌───────────┐     │                    │                       │                                     │                          │
│  Flow     │     │    Runs            │                       │                                     │                          │
│   of   │  │     │    `ruby app.rb`   │                       │                                     │                          │
│  Time  │  │     ├───────────────────►│   Opens connection to database calling method `connect`     │                          │
│        ▼  │     │                    │   on DatabaseConnection                                     │                          │
└───────────┘     │                    ├───────────────────────┬────────────────────────────────────►│                          │
                  │                    │                       │   Opens database connection using PG│and stores the connection │
                  │                    │                       │                                     ├─────┐                    │
                  │                    │ Calls method `all`    │                                     │     │                    │
                  │                    │ on BookRepository     │                                     │     │                    │
                  │                    ├──────────────────────►│                                     │◄────┘                    │
                  │                    │                       │                                     │                          │
                  │                    │                       │Sends SQL query by calling method    │                          │
                  │                    │                       │`exec_params` on DatabaseConnection  │                          │
                  │                    │                       ├────────────────────────────────────►│                          │
                  │                    │                       │                                     │ Sends query to database  │
                  │                    │                       │                                     │ via the open database    │
                  │                    │                       │                                     │ connection               │
                  │                    │                       │                                     ├──────────────────────────►
                  │                    │                       │                                     │ Returns an array of      │
                  │                    │                       │                                     │ hashes, one for each row │
                  │                    │                       │                                     │ of the books table       │
                  │                    │                       │  Returns an array of hashes,        │◄─────────────────────────┤
                  │                    │                       │  one for each row of the books table│                          │
                  │                    │                       │◄────────────────────────────────────┤                          │
                  │                    │                       │                                     │                          │
                  │                    │             ┌─────────┴─────────┐                           │                          │
                  │                    │             │                   │Loops through array and    │                          │
                  │                    │             │       loop        │creates an Book object     │                          │
                  │                    │             │                   │for every row              │                          │
                  │                    │             └─────────┬─────────┘                           │                          │
                  │                    │ Returns array of      │                                     │                          │
                  │ Prints list of     │ Book objects          │                                     │                          │
                  │ books to terminal  │◄──────────────────────┤                                     │                          │
                  │◄───────────────────┤                       │                                     │                          │
                  │                    │                       │                                     │                          │
         ┌────────┴───────┐  ┌─────────┴───────┐ ┌─────────────┴──────────────┐   ┌──────────────────┴─────────────┐ ┌──────────┴─────────┐
         │  Terminal      │  │  Main program   │ │ BookRepository class       │   │ DatabaseConnection class       │ │ Postgres database  │
         │                │  │  (app.rb)       │ │ (in lib/book_repository.rb)│   │ (in lib/database_connection.rb)│ │                    │
         │                │  │                 │ │                            │   │                                │ │                    │
         └────────────────┘  └─────────────────┘ └────────────────────────────┘   └────────────────────────────────┘ └────────────────────┘
```

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_books.sql)

-- Write your SQL seed here.

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE books RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO books (title, author_name) VALUES ('Emma', 'Jane Austen');
INSERT INTO books (title, author_name) VALUES ('Dracula', 'Bram Stoker');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: books

# Model class
# (in lib/book.rb)
class Book
end

# Repository class
# (in lib/book_repository.rb)
class BookRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: books

# Model class
# (in lib/book.rb)

class Book

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :author_name
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```

_You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed._

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: Books

# Repository class
# (in lib/book_repository.rb)

class BookRepository

  # Selecting all books
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, author_name FROM books;

    # Returns an array of Books objects.
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all books

repo = BookRepository.new

books = repo.all

books.length # =>  2
books.first.title # => Emma
books.first.author_name # => Jane Austen
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/book_repository_spec.rb

def reset_books_table
  seed_sql = File.read('spec/seed_books.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'book_store_test' })
  connection.exec(seed_sql)
end

describe BookRepository do
  before(:each) do
    reset_books_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->
