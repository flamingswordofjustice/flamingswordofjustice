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
      f.input :embedded_content, hint: "E.g., a YouTube video. When embedding, use the embed version of the URL: https://www.youtube.com/embed/ABCD1234"
      f.input :content, as: :html_editor
    end

    f.inputs "Social and Sharing" do
      redirects = Redirect.pointed_at(f.object).order(:path)
      f.input :redirect, label: "Canonical short link",
        collection: redirects,
        selected: f.object.redirect_id || redirects.first.try(:id),
        hint: link_to("Add new redirect", new_admin_redirect_path, target: "_new")

      f.input :headline, label: "Catchy headline"

      f.input :social_description, label: "Pithy Facebook description",
        hint: content_tag(:span, "", class: "charlimit"),
        input_html: { rows: 3, maxlength: 100 }

      f.input :twitter_text, label: "Viral Twitter text",
        as: :text,
        hint: content_tag(:span, "", class: "charlimit") + t("admin.twitter_text").html_safe,
        input_html: { rows: 3, maxlength: 102 }
    end

    f.actions
  end
end
