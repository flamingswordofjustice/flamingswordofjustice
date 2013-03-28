ActiveAdmin.register User do
  index do
    column :email
    column :name
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form html: { multipart: true } do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :name
      f.input :image, as: :image_upload, preview: :thumb
    end
    f.actions
  end
end
