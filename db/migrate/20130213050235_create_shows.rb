class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :title
      t.string :download_url
      t.text :blurb
      t.boolean :published
      t.date :recorded_at
      t.timestamps
    end
  end
end
