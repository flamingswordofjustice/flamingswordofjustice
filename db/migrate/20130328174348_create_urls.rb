class CreateUrls < ActiveRecord::Migration
  def change
    create_table :redirects do |t|
      t.string :path, null: false
      t.string :destination, null: false
      t.integer :hits, default: 0
    end

    add_index :redirects, :path, unique: true
  end
end
