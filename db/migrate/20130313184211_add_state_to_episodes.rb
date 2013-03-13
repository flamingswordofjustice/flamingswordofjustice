class AddStateToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :state, :string
    add_index :episodes, :state
    Episode.unscoped.update_all state: "published"
  end
end
