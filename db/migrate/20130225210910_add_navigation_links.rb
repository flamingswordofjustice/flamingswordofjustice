class AddNavigationLinks < ActiveRecord::Migration
  def change
    create_table :navigation_links do |t|
      t.string :title
      t.string :location
      t.integer :parent_link_id
      t.integer :page_id
      t.integer :position
    end
  end
end
