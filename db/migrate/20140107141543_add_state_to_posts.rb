class AddStateToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :state, :string
    add_index :posts, :state
    Post.unscoped.update_all state: "published"
  end
end
