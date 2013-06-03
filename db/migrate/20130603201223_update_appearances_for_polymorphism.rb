class UpdateAppearancesForPolymorphism < ActiveRecord::Migration
  class Appearance < ActiveRecord::Base
  end

  def up
    change_column :appearances, :guest_type, :string
    add_column :organizations, :appearances_count, :int, default: 0
    Appearance.update_all guest_type: Person.name
  end

  def down
    drop_column :organizations, :appearances_count
  end
end
