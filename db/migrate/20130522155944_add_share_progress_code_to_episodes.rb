class AddShareProgressCodeToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :share_progress_code, :string
  end
end
