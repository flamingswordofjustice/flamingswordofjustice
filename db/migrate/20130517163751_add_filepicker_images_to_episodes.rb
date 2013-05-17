class AddFilepickerImagesToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :filepicker_images, :string
  end
end
