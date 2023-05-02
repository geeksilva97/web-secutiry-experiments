require 'sinatra'
require 'sqlite3'

# Initialize the database
db = SQLite3::Database.new 'database.db'

# Create the table
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    name TEXT,
    age INTEGER,
    password TEXT
  );
SQL

# Seed the database with some users
# db.execute("INSERT INTO users (name, age, password) VALUES ('John', 25, '123abc')")
# db.execute("INSERT INTO users (name, age, password) VALUES ('Jane', 30, 'webmaster')")

# Search route
get '/search' do
  # Get the search term from the query string
  search_term = params[:term]

  # Construct the SQL query with the search term
  sql_query = "SELECT id, name, age FROM users WHERE name LIKE '%#{search_term}%'"

  puts "\n"
  pp sql_query
  puts "\n"

  # Execute the query and display the results
  results = db.execute(sql_query)

  pp results

  # Return the results as HTML
  result_html = ''
  results.each do |result|
    pp result
    result_html += "<li>Name: #{result[1]}, Age: #{result[2]}</li>"
  end

  "<h1>Search Results</h1><ul>#{result_html}</ul>"
end
