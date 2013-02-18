ActiveAdmin.register Organization do
  index do
    column :name
    column :guests
    column :created_at
    default_actions
  end

  form html: { multipart: true } do |f|
    f.inputs "Guest Details" do
      f.input :name
      f.input :website
      f.input :twitter
      f.input :facebook
      f.input :guests
      f.input :image, as: :file
      f.input :description, as: :html_editor
    end
    f.actions
  end

end
