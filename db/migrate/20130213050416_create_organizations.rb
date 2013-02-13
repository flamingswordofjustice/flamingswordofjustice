class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :website
      t.text :description
      t.string :logo_url
      t.timestamps
    end
  end
end
