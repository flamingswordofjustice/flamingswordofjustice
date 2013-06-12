ActiveAdmin.register Person do
  index do
    column :name
    column :appearances
    column :title
    column :email
    column :created_at
    column :organization
    default_actions
  end

  show do
    render partial: 'admin/shared/iframe', locals: { src: person_url(person) }
  end

  action_item only: [:edit, :show] do
    name = resource.class.model_name
    link_to "View Live #{active_admin_config.resource_label}", polymorphic_url(resource, protocol: "http"), target: "_new"
  end

  form html: { multipart: true } do |f|
    f.inputs "Guest Details" do
      f.input :name
      f.input :email, hint: "Publicly displayed so users can email directly"
      f.input :title,
        hint: content_tag(:span, "", class: "charlimit") + "Include the organization name, e.g. 'CEO of JusticeCorp'",
        input_html: { maxlength: 100 }

      f.input :organization
      f.input :website, hint: "Full URL, including http://"
      f.input :twitter, hint: "Just the username - no http, no @ symbol"
      f.input :facebook, hint: "Just the username - no http"
      f.input :public_email, hint: "Optional - will be shown on site if provided."
      f.input :image, as: :image_upload, preview: :thumb
      f.input :description, as: :html_editor
    end
    f.actions
  end
end
