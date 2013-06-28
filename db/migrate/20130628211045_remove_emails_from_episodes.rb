class RemoveEmailsFromEpisodes < ActiveRecord::Migration
  def change
    remove_column :episodes, :email_proofed_at
    remove_column :episodes, :email_proofed_by_id
    remove_column :episodes, :email_note
  end
end
