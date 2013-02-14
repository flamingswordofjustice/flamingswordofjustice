ActiveAdmin.register Episode do
  index do
    column :title
    column :recorded_at
    column :guests
    column :description
    default_actions
  end

  filter :recorded_at

  form html: { multipart: true } do |f|
    f.inputs "Episode Details" do
      f.input :title
      f.input :download_url
      f.input :description, as: :html_editor
      f.input :recorded_at
      f.input :image, as: :file
      f.input :guests
    end
    f.actions
  end
end
