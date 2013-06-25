class AddYoutubeVideoIdToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :youtube_video_id, :string
  end
end
