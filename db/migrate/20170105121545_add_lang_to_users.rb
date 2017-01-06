class AddLangToUsers < ActiveRecord::Migration[5.0]
  def change
      add_column :users, :lang, :string, default: "en"
  end
end
