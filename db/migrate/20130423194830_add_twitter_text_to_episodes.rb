class AddTwitterTextToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :twitter_text, :string
  end
end
