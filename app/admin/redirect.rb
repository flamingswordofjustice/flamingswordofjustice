ActiveAdmin.register Redirect do
  actions :all, except: [:show]

  index do
    column :redirect do |redirect|
      link_to("http://fsj.fm/" + redirect.path, redirect.path, style: "") + " &#8594; ".html_safe + link_to(redirect.destination, redirect.destination)
    end
    column :hits
    column "2-hour activity" do |redirect|
      content_tag(:span, "stats.redirects.#{redirect.path}", class: "sparkline")
    end
    column :notes
    default_actions
  end

  form do |f|
    f.inputs "Redirect details" do
      f.input :linkable_id,
        label: "Internal Location",
        as: :polymorphic_select,
        collection: f.object.linkables,
        option_label: :linkable_title,
        hint: "Use EITHER this OR External Location below."

      f.input :linkable_type, as: :hidden

      f.input :destination,
        label: "External Location",
        hint: "Use EITHER this OR Internal Location above. The destination path for the redirect, e.g. '/episodes/14-this-is-an-episode' or 'https://google.com'."

      f.input :path, hint: "The public path. For http://fsj.fm/14, this should be '14'. Leave this blank to auto-generate a hash."
      f.input :notes
    end
    f.actions
  end
end
