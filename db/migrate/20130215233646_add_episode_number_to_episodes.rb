class AddEpisodeNumberToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :number, :string
  end
end
