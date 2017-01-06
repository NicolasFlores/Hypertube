class Addfieldtomovie < ActiveRecord::Migration[5.0]
  def change
    add_column :movies, :url, :string
    add_column :movies, :torrent, :string
  end
end
