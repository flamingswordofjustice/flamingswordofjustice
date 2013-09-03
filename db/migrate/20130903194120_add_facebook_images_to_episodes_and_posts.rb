class AddFacebookImagesToEpisodesAndPosts < ActiveRecord::Migration
  def change
    add_column :episodes, :facebook_image_url, :string

    change_table :posts do |t|
      t.string   "facebook_image_url"
      t.string   "headline"
      t.text     "social_description"
      t.string   "twitter_text"
      t.integer  "redirect_id"
      t.integer  "public_author_id"
    end
  end
end
