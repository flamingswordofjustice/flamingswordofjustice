ActiveAdmin.register Organization do
  menu label: "Orgs"

  index do
    column :name
    column(:people) { |o| o.people.map {|p| link_to p.name, edit_admin_person_path(p.slug) }.join(', ').html_safe }
    column :created_at
    default_actions
  end

  show do
    render partial: 'admin/shared/iframe', locals: { src: organization_url(organization) }
  end

  action_item only: [:edit, :show] do
    name = resource.class.model_name
    link_to "View Live #{active_admin_config.resource_label}", polymorphic_url(resource, protocol: "http"), target: "_new"
  end

  form html: { multipart: true } do |f|
    f.inputs "Organization Details" do
      f.input :name
      f.input :website, hint: "Full URL, including http://"
      f.input :twitter, hint: "Just the username - no http, no @ symbol"
      f.input :facebook, hint: "Just the username - no http"
      f.input :short_description,
        hint: content_tag(:span, "", class: "charlimit") + "For display in the organizaton badge.",
        input_html: { maxlength: 100 }
      f.input :description, as: :html_editor
      f.input :image, as: :image_upload, preview: :logo
      f.input :people, as: :select, multiple: true, collection: Person.all, selected: f.object.people.map(&:id)
    end
    f.actions
  end

end
