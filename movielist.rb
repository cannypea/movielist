require 'sqlite3'

class MovieList
  attr_accessor :db
  
  def initialize(db_name)
    @db = SQLite3::Database.new(db_name)
    create_table
  end

  def create_table
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS movielist (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        genre TEXT,
        director TEXT
      );
    SQL
  end

  def add_movie(title, genre, director)
    @db.execute("INSERT INTO movielist (title, genre, director) VALUES (?, ?, ?)", [title, genre, director])
    puts "Movie '#{title}' added."
    list_movies
  end

  def remove_movie(title)
    @db.execute("DELETE FROM movielist WHERE title = ?", [title])
    puts "Movie '#{title}' removed."
    list_movies
  end

  def update_movie(title, new_title, new_genre, new_director)
    @db.execute("UPDATE movielist SET title = ?, genre = ?, director = ? WHERE title = ?", [new_title, new_genre, new_director, title])
    puts "Movie '#{title}' updated."
    list_movies
  end

  def list_movies
    puts "Movie List:"
    @db.execute("SELECT * FROM movielist") do |row|
      puts "#{row[0]}. Title: #{row[1]}, Genre: #{row[2]}, Director: #{row[3]}"
    end
  end
end

# Main program
if __FILE__ == $PROGRAM_NAME
  db_name = "movielist.db"
  movie_list = MovieList.new(db_name)

  loop do
    puts "\nOptions: add / remove / update / list / exit"
    print "Enter your choice: "
    choice = gets.chomp.downcase

    case choice
    when 'add'
      print "Enter movie title: "
      title = gets.chomp
      print "Enter genre: "
      genre = gets.chomp
      print "Enter director: "
      director = gets.chomp
      movie_list.add_movie(title, genre, director)
    when 'remove'
      print "Enter movie title to remove: "
      title = gets.chomp
      movie_list.remove_movie(title)
    when 'update'
      print "Enter movie title to update: "
      old_title = gets.chomp
      print "Enter new movie title: "
      new_title = gets.chomp
      print "Enter new genre: "
      new_genre = gets.chomp
      print "Enter new director: "
      new_director = gets.chomp
      movie_list.update_movie(old_title, new_title, new_genre, new_director)
    when 'list'
      movie_list.list_movies
    when 'exit'
      break
    else
      puts "Invalid choice. Please try again."
    end
  end
end
