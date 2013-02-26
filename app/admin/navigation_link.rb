ActiveAdmin.register NavigationLink do
  config.filters = false

  form do |f|
    f.inputs "Link details" do
      f.input :title
      f.input :location, hint: "Leave blank if you want this to be a parent link."
      f.input :page, hint: "Leave blank if you want this to be a parent link."
      f.input :parent_link, as: :select, collection: Hash[f.object.potential_parents.map {|nl| [nl.title, nl.id]}]
    end
    f.actions
  end

  controller do
    def active_admin_collection
      NavigationLink.ordered_by_position.page(params[:page]).per(100)
    end
  end

  index do
    column :title do |link|
      if link.root_link?
        link.title
      else
        link.parent_link.title + " > " + link.title
      end
    end
    column :parent_link
    column :url

    default_actions
    column :move_position do |link|
      up_link = if link.first?
        link_to icon(:arrow_up, color: "#eee !important"), "#", disabled: true
      else
        link_to icon(:arrow_up), up_admin_navigation_link_path(link), method: :put
      end

      down_link = if link.last?
        link_to icon(:arrow_down, color: "#eee !important"), "#", disabled: true
      else
        link_to icon(:arrow_down), down_admin_navigation_link_path(link), method: :put
      end

      safe_join [ up_link, down_link ]
    end
  end

  member_action :up, :method => :put do
    link = NavigationLink.find(params[:id])
    link.move_higher
    redirect_to({action: :index}, {notice: "Position is #{link.position}"})
  end

  member_action :down, :method => :put do
    link = NavigationLink.find(params[:id])
    link.move_lower
    redirect_to({action: :index}, {notice: "Position is #{link.position}"})
  end

end
