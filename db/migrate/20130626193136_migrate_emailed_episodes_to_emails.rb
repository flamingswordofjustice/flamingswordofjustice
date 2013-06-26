class MigrateEmailedEpisodesToEmails < ActiveRecord::Migration
  class Email < ActiveRecord::Base
  end

  class Episode < ActiveRecord::Base
  end

  def up
    rename_column :emails, :proofed_by, :proofed_by_id

    Email.reset_column_information
    Email.delete_all

    Episode.where("email_proofed_at IS NOT NULL").each do |e|
      Email.create(
        subject:       ( e.headline || e.title ),
        proofed_at:    e.email_proofed_at,
        proofed_by_id: e.email_proofed_by_id,
        header_note:   e.email_note,
        episode_id:    e.id
      )
    end
  end

  def down
    # Will remove relevant episode columns after migration.
    rename_column :emails, :proofed_by_id, :proofed_by
  end
end
