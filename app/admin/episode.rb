ActiveAdmin.register Episode do
  index do
    column "Name", :title
    column :headline
    column :published_at
    column(:guests) { |e| e.guests.map {|g| link_to g.name, edit_admin_person_path(g.slug) }.join(', ').html_safe }
    column(:topics) { |e| e.topics.map {|t| link_to t.name, edit_admin_topic_path(t.slug) }.join(', ').html_safe }
    column(:description, sortable: :description) { |e| strip_tags e.description }
    default_actions
  end

  filter :published_at

  form html: { multipart: true } do |f|
    f.inputs "Episode Details" do
      f.input :title, label: "Name"
      f.input :headline
      f.input :download_url
      f.input :description, as: :html_editor
      f.input :published_at, as: :date_select
      f.input :topics, hint: link_to("Add new topic", new_admin_topic_path, target: "_new")
      f.input :guests, hint: link_to("Add new guest", new_admin_person_path, target: "_new")
      f.input :image, as: :file, hint: image_tag(f.object.image.thumb.url)
    end
    f.actions
  end
end
