ActiveAdmin.register Guest do
    # t.string   "name"
    # t.integer  "organization_id"
    # t.text     "bio"
    # t.string   "website"
    # t.string   "twitter"
    # t.string   "linkedin"
    # t.string   "photo_url"

  form do |f|
    f.inputs "Guest Details" do
      f.input :name
      f.input :organization
      f.input :website
      f.input :twitter
      f.input :linkedin
      f.input :bio, as: :html_editor
    end
    f.actions
  end

end
