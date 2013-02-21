class AddAppearancesCountToPeople < ActiveRecord::Migration
  def change
    add_column :people, :appearances_count, :integer, default: 0
    add_index :people, :appearances_count
  end
end
