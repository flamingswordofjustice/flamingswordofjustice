ActiveAdmin.register Post do
  index do
    column :title
    column :slug
    column :author
    column :topics
    default_actions
  end

  show do
    render partial: 'admin/shared/iframe', locals: { src: post_url(post) }
  end

  action_item only: [:edit, :show] do
    name = resource.class.model_name
    link_to "View Live #{active_admin_config.resource_label}", polymorphic_url(resource, protocol: "http"), target: "_new"
  end

  form do |f|
    f.inputs "Show Details" do
      f.input :title
      f.input :author
      f.input :topics
      f.input :slug, hint: "Optional - will be generated as needed"
      f.input :content, as: :html_editor
    end
    f.actions
  end
end
