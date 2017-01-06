class CommentsController < ApplicationController
  def add
      Comment.create user_id: current_user.id, movie_id: params[:id_movie], message: params[:message]
      redirect_to "/movies/#{params[:id_movie]}"
  end
end
