class FilepickerImagesFieldNeedsToBeLonger < ActiveRecord::Migration
  def change
    change_column :episodes, :filepicker_images, :text
  end
end
