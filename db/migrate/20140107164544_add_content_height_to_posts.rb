class AddContentHeightToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :content_height, :integer
  end
end
