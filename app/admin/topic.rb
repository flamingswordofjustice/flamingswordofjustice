ActiveAdmin.register Topic do
  show do
    render partial: 'admin/shared/iframe', locals: { src: topic_url(topic) }
  end
end
