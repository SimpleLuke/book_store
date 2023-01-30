require 'book_repository'

describe BookRepository do
  def reset_books_table
    seed_sql = File.read('spec/seed_books.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'book_store_test' })
    connection.exec(seed_sql)
  end

    before(:each) do
      reset_books_table
    end

    # (your tests will go here).
  it 'returns an array of Book Oject' do
    repo = BookRepository.new
    books = repo.all

    expect(books.length).to eq 2 # =>  2
    expect(books.first.title).to eq 'Emma' # => Emma
    expect(books.first.author_name).to eq 'Jane Austen' # => Jane Austen
  end
end
