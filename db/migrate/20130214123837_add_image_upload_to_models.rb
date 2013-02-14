class AddImageUploadToModels < ActiveRecord::Migration
  def change
    add_column    :episodes, :image, :string
    rename_column :episodes, :blurb, :description

    add_column    :guests, :image, :string
    add_column    :users, :image, :string

    rename_column :guests, :bio, :description
    remove_column :guests, :linkedin
    remove_column :guests, :photo_url
    add_column    :guests, :facebook, :string

    remove_column :organizations, :logo_url
    add_column    :organizations, :image, :string
    add_column    :organizations, :twitter, :string
    add_column    :organizations, :facebook, :string
  end
end
