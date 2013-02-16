class ConvertPublishedAtToDatetime < ActiveRecord::Migration
  def change
    change_column :episodes, :published_at, :datetime
  end
end
