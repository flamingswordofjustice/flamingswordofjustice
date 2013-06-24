class AddEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :subject
      t.string :sender
      t.string :recipient
      t.integer :episode_id
      t.text :body
      t.text :header_note
      t.datetime :sent_at
      t.datetime :proofed_at
      t.integer :proofed_by
      t.timestamps
    end
  end
end
