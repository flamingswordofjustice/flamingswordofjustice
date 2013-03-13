ActiveAdmin.register Topic do
  show do
    render partial: 'admin/shared/iframe', locals: { src: topic_url(topic) }
  end

  form html: { multipart: true } do |f|
    f.inputs "Topic Details" do
      f.input :name
      hint = f.object.image.present? ? image_tag(f.object.image.logo.url) : nil
      f.input :image, as: :file, hint: hint
      f.input :description, as: :html_editor
    end
    f.actions
  end
end
