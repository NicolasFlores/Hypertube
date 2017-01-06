class Movie < ApplicationRecord

  CATEGORIES = %w(
    Action Adventure Animation Biography Comedy Crime Documentary Drama Family Fantasy Film-Noir Game-Show History Music Horror
    Musical Mystery News Reality-TV Sci-Fi Sport Talk-Show Thriller War Western
  )

  URL = "https://yts.ag/api/v2/"

  has_many :users, through: :users_movie
  # has_many :comments

  def self.get_movies(params, genres)
    url = "#{URL}list_movies.json?limit=24&sort_by=rating" + genres
    json = open(url).read
    return JSON.parse(json), url
  end

  def self.get_movie(id)
    url = "#{URL}movie_details.json?movie_id=#{id}"
    puts url
    json = open(url).read
    return JSON.parse(json)['data']['movie']
  end

end
