class AddSlugsToGuestsAndOrganizations < ActiveRecord::Migration
  def change
    add_column :guests, :slug, :string
    add_index :guests, :slug, unique: true

    add_column :organizations, :slug, :string
    add_index :organizations, :slug, unique: true
  end
end
