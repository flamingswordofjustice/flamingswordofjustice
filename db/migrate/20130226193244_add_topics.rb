class AddTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.text :description
      t.string :image
      t.string :slug
    end

    add_index :topics, :slug, unique: true

    create_table :topic_assignments do |t|
      t.integer :topic_id
      t.integer :assignable_id
      t.string  :assignable_type
    end

    add_index :topic_assignments, [:assignable_id, :assignable_type]

    remove_column :posts, :tags
  end
end
