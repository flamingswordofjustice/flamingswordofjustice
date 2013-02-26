ActiveAdmin.register Episode do
  index do
    column :title
    column :published_at
    column :guests
    column :description
    default_actions
  end

  filter :published_at

  form html: { multipart: true } do |f|
    f.inputs "Episode Details" do
      f.input :title
      f.input :download_url
      f.input :description, as: :html_editor
      f.input :published_at, as: :date_select
      f.input :image, as: :file
      f.input :guests
    end
    f.actions
  end
end
