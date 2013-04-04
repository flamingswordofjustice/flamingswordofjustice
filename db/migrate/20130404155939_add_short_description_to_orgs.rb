class AddShortDescriptionToOrgs < ActiveRecord::Migration
  def change
    add_column :organizations, :short_description, :string
  end
end
