class RenameGuestsToPeople < ActiveRecord::Migration
  def change
    rename_table :guests, :people
  end
end
