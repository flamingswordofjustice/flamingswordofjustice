ActiveAdmin.register Guest do
  index do
    column :name
    column :appearances
    column :created_at
    default_actions
  end

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
