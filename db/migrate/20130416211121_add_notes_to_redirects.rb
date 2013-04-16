class AddNotesToRedirects < ActiveRecord::Migration
  def change
    add_column :redirects, :notes, :text
  end
end
