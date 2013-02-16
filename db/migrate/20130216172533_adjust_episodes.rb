class AdjustEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :libsyn_id, :string # To uniquely identify the episode and avoid re-importing old ones.
    add_column :episodes, :notes, :text # To distinguish from the shorter description.
    rename_column :episodes, :recorded_at, :published_at # To be consistent with libsyn/RSS.
  end
end
