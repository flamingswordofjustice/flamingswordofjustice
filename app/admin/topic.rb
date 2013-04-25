ActiveAdmin.register Topic do
  show do
    render partial: 'admin/shared/iframe', locals: { src: topic_url(topic) }
  end

  action_item only: [:edit, :show] do
    name = resource.class.model_name
    link_to "View Live #{active_admin_config.resource_label}", polymorphic_path(resource), target: "_new"
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
