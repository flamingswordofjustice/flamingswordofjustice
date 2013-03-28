ActiveAdmin.register Topic do
  show do
    render partial: 'admin/shared/iframe', locals: { src: topic_url(topic) }
  end

  form html: { multipart: true } do |f|
    f.inputs "Topic Details" do
      f.input :name
      f.input :image, as: :image_upload, preview: :logo
      f.input :description, as: :html_editor
    end
    f.actions
  end
end
