class AddEmailToPeople < ActiveRecord::Migration
  def change
    add_column :people, :email, :string
    add_column :people, :public_email, :string
  end
end
