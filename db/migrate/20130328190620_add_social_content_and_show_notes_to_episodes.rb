class AddSocialContentAndShowNotesToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :social_description, :text
    add_column :episodes, :show_notes, :text
    add_column :episodes, :image_caption, :string
  end
end
