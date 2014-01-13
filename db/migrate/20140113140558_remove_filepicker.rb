class RemoveFilepicker < ActiveRecord::Migration
  def change
    remove_column :episodes, :filepicker_images
    remove_column :episodes, :facebook_image_url
    remove_column :posts, :facebook_image_url
  end
end
