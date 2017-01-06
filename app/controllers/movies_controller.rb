class MoviesController < ApplicationController
  require 'find'
  require 'open-uri'

  def index
    genres = ""
    current_query_string = URI(request.url).query
    unless current_query_string.nil?
      genres_arr = URI::decode_www_form(current_query_string).select { |pair| pair[0] == "genre" }.collect { |pair| pair[1] }
      genres_arr.each do |genre|
        genres += "&genre=#{genre}"
      end
    end
    @movies, @url = Movie::get_movies(params, genres)
  end

  def show
    @movie = Movie::get_movie(params[:id])
    @id_movie = params[:id]
    @comment = Comment::get_comments(params[:id])
  end

  def add_movie_collection
    puts params.inspect

    @movie = Movie.where(torrent: params["torrent"]).first
    if @movie.nil?
      @movie = Movie.create({torrent: params["torrent"]})
      UsersMovie.create({user_id: current_user.id, movie_id: @movie.id})
    else
      @user_movie = UsersMovie.where(user_id: current_user.id, movie_id: @movie.id).first
      if @user_movie.nil?
        UsersMovie.create({user_id: current_user.id, movie_id: @movie.id})
      else
        #deja dans la collection
      end
    end

    render json: {}
  end

  def download
      try_get_movie = Movie.where(torrent: params[:hash]).first
      if not try_get_movie
          download = open(params[:url])
          name = params[:hash] + '.torrent'
          path = Rails.root.join('public', 'videos') + name
          IO.copy_stream(download, path)
          conf = { host: "localhost", port: 9091, user: "admin", pass: "admin", path: "/transmission/rpc" }
          Trans::Api::Client.config = conf
          Trans::Api::Torrent.default_fields = [ :id, :status, :name ]

          file = File.open(path)
          file_name = File.basename(file, ".*") # required >= 0.0.3/ master
          options = {paused: false}
          base64_file_contents = Base64.encode64 file.read
          torrent = Trans::Api::Torrent.add_metainfo base64_file_contents, file_name, options
        #   torrent.waitfor( lambda{|t| t.status_name != :stopped} )
        #   sleep(5)
          torrent.files_objects.each do |item|
              if item.name['.mp4'] or item.name['.mkv']
                  @movie_file_name = item.name
              end
          end
          Movie.create movie_id: params[:id_movie], path: @movie_file_name, users_view_id: session[:id_user].to_s, torrent: params[:hash]
      else
          users = try_get_movie.users_view_id.split(",")
          @movie_file_name = try_get_movie.path
          unless users.include? session[:id_user].to_s
              puts session[:id_user]
              users << session[:id_user].to_s
              users_to_s = users.join(",")
              try_get_movie.update users_view_id: users_to_s
          end
      end
      @verif = 1
      while @verif == 1 do
          Dir.glob(Rails.root.join('public', 'videos', '**', '*')) do |file|
              if file["" + @movie_file_name]
                  @verif = 0
              end
          end
      end
    #   sleep(10)
    #   redirect_to "/movies/stream/#{params[:id_movie]}/#{params[:hash]}"
  end

  def stream
      path = Movie.where(movie_id: params[:id_movie], torrent: params[:hash]).first.path
      @movie_file = '/videos/' + path
  end

end
