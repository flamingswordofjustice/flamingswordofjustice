class RemoveShareProgressCode < ActiveRecord::Migration
  def up
    remove_column :episodes, :share_progress_code
  end

  def down
    add_column :episodes, :share_progress_code, :string
  end
end
