ActiveAdmin.register Post do
  index do
    column :title
    column :slug
    column :author
    column :topics
    default_actions
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
