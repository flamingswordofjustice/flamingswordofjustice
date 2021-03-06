class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug
      t.string :tags
      t.text :content
      t.integer :author_id
      t.timestamps
    end
  end
end
