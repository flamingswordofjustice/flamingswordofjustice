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

  form html: { multipart: true } do |f|
    f.inputs "Guest Details" do
      f.input :name
      f.input :email, hint: "Publicly displayed so users can email directly"
      f.input :title, hint: "Include the organization name, e.g. 'CEO of JusticeCorp'"
      f.input :organization
      f.input :website, hint: "Full URL, including http://"
      f.input :twitter, hint: "Just the username - no http, no @ symbol"
      f.input :facebook, hint: "Just the username - no http"
      f.input :public_email, hint: "Optional - will be shown on site if provided."
      f.input :image, as: :file, hint: image_tag(f.object.image.thumb.url)
      f.input :description, as: :html_editor
    end
    f.actions
  end
end
