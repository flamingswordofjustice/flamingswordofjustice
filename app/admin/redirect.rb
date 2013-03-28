ActiveAdmin.register Redirect do
  form do |f|
    f.inputs "Redirect details" do
      f.input :path, hint: "The public path. For http://fsj.fm/14, this should be '14'. Leave this blank to auto-generate a hash."
      f.input :destination, hint: "The destination path for the redirect, e.g. '/episodes/14-this-is-an-episode' or 'https://google.com'."
    end
    f.actions
  end
end
