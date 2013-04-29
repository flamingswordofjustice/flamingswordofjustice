class AddEmailProofingToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :email_proofed_at, :datetime
    add_column :episodes, :email_proofed_by_id, :integer
    add_column :episodes, :email_note, :text
  end
end
