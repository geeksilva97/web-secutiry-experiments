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
# db.execute("INSERT INTO users (name, age, password) VALUES ('Edy', 30, 'webmaster')")

def render_result(results)
  return '' if results.empty?

  html_content = ''

  results.each do |result|
    html_content += "<li>Name: #{result[1]}, Age: #{result[2]}</li>"
  end

  "<h1>Search Results</h1><ul>#{html_content}</ul>"
end

def query_by_term_secure(db, term)
  return [] if term.nil? || term.empty?

  stmt = db.prepare('SELECT id, name, age FROM users WHERE name LIKE ?')
  stmt.bind_param(1, "%#{term}%")

  res = stmt.execute
  rows = []
  row = res.next

  while row
    rows << [row[0], row[1], row[2]]

    row = res.next
  end

  rows
end

def query_by_term(db, term)
  return [] if term.nil? || term.empty?

  sql_query = "SELECT id, name, age FROM users WHERE name LIKE '%#{term}%'"

  db.execute(sql_query)
end

# Search route
get '/search' do
  # Get the search term from the query string
  search_term = params[:search_term]

  # Construct the SQL query with the search term
  # sql_query = "SELECT id, name, age FROM users WHERE name LIKE '%#{search_term}%'"

  # Execute the query and display the results
  results = query_by_term_secure(db, search_term)

  pp results

  # Return the results as HTML
  # result_html = ''
  # results.each do |result|
  #   result_html += "<li>Name: #{result[1]}, Age: #{result[2]}</li>"
  # end

  <<-HTML
    <h1>A pretty obvious search form</h1>
    <form method="get">
      <label for="search">Search:</label>
      <input type="search" name="search_term" id="search">
      <br>
      <input type="submit" value="Submit">
    </form>

    #{render_result(results)}
  HTML

  # "<h1>Search Results</h1><ul>#{result_html}</ul>"
end
