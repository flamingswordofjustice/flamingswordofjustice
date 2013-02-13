class CreateAppearances < ActiveRecord::Migration
  def change
    create_table :appearances do |t|
      t.text :description
      t.integer :guest_id
      t.integer :guest_type
      t.integer :show_id
      t.timestamps
    end
  end
end
