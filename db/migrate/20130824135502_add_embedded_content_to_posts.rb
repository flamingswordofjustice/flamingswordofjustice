class AddEmbeddedContentToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :embedded_content, :string
  end
end
