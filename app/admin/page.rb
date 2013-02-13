ActiveAdmin.register Page do
  form do |f|
    f.inputs "Show Details" do
      f.input :title
      f.input :slug, hint: "Optional - will be generated as needed"
      f.input :content, as: :html_editor
    end
    f.actions
  end
end
