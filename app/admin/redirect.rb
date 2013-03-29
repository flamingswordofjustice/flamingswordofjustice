ActiveAdmin.register Redirect do
  actions :all, except: [:show]

  index do
    column :redirect do |redirect|
      link_to("http://fsj.fm/" + redirect.path, redirect.path, style: "") + " &#8594; ".html_safe + link_to(redirect.destination, redirect.destination)
    end
    column :hits
    default_actions
  end

  form do |f|
    f.inputs "Redirect details" do
      f.input :destination, hint: "The destination path for the redirect, e.g. '/episodes/14-this-is-an-episode' or 'https://google.com'."
      f.input :path, hint: "The public path. For http://fsj.fm/14, this should be '14'. Leave this blank to auto-generate a hash."
    end
    f.actions
  end
end
