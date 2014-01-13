class AddSocialImagesWithCarrierwave < ActiveRecord::Migration
  def change
    add_column :episodes, :social_image, :string
    add_column :posts, :social_image, :string
  end
end
