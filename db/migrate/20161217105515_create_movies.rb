class CreateMovies < ActiveRecord::Migration[5.0]
  def change
    create_table :movies do |t|
        t.string "movie_id",      default: "", null: false
        t.string "path",          default: "", null: false
        t.string "name",          default: "", null: false
        t.text   "users_view_id", default: "", null: false
        t.timestamps
    end
  end
end
