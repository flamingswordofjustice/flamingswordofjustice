class AddShortLinkReferenceToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :redirect_id, :integer
  end
end
