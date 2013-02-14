class RenameShowsToEpisodes < ActiveRecord::Migration
  def change
    rename_table :shows, :episodes
    rename_column :appearances, :show_id, :episode_id
  end
end
