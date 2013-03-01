class AddHeadlinesToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :headline, :string
  end
end
