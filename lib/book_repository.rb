require_relative './book.rb'

class BookRepository
  def all
    books = []
    sql = 'SELECT id, title, author_name FROM books;'
    result_set = DatabaseConnection.exec_params(sql,[]);

    result_set.each do |record|
      book = Book.new
      book.id = record['id']
      book.title = record['title']
      book.author_name = record['author_name']

      books << book
    end
    return books
  end
end
