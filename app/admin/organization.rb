ActiveAdmin.register Organization do
  menu label: "Orgs"

  index do
    column :name
    column :people
    column :created_at
    default_actions
  end

  show do
    render partial: 'admin/shared/iframe', locals: { src: organization_url(organization) }
  end

  form html: { multipart: true } do |f|
    f.inputs "Guest Details" do
      f.input :name
      f.input :website, hint: "Full URL, including http://"
      f.input :twitter, hint: "Just the username - no http, no @ symbol"
      f.input :facebook, hint: "Just the username - no http"
      f.input :people
      f.input :image, as: :file, hint: image_tag(f.object.image.thumb.logo)
      f.input :description, as: :html_editor
    end
    f.actions
  end

end
