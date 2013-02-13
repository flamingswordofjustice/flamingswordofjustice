ActiveAdmin.register Show do
  index do
    column :title
    column :recorded_at
    column :guests
    column :blurb
    default_actions
  end

  filter :recorded_at

  form do |f|
    f.inputs "Show Details" do
      f.input :title
      f.input :download_url
      f.input :blurb, as: :html_editor
      f.input :recorded_at
      f.input :guests
    end
    f.actions
  end
end
