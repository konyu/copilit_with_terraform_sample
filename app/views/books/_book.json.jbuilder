json.extract! book, :id, :title, :author, :price, :created_at, :updated_at
json.url book_url(book, format: :json)
