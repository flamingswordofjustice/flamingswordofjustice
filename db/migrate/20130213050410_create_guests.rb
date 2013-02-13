class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :name
      t.integer :organization_id
      t.text :bio
      t.string :website
      t.string :twitter
      t.string :linkedin
      t.string :photo_url
      t.timestamps
    end
  end
end
