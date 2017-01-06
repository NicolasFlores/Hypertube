class Comment < ApplicationRecord

    belongs_to :user
    # belongs_to :movie

    def self.get_comments(movie_id)
        comments = Comment.where(movie_id: movie_id).all
        return comments
    end
end
