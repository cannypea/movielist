require 'minitest/autorun'
require_relative '../movielist'

class MovieListTest < Minitest::Test
  def setup
    @db_name = "test_movielist.db"
    @movie_list = MovieList.new(@db_name)
  end

  def test_add_movie
    @movie_list.add_movie("The Shawshank Redemption", "Drama", "Frank Darabont")
    movies = @movie_list.db.execute("SELECT * FROM movielist WHERE title = 'The Shawshank Redemption'")
    assert_equal 1, movies.length
    assert_equal ["The Shawshank Redemption", "Drama", "Frank Darabont"], movies.first[1..]
  end

  def teardown
    File.delete(@db_name) if File.exist?(@db_name)
  end
end
