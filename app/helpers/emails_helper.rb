module EmailsHelper

  def public_image_tag(source, options)
    protocol = Rails.env.development? ? :http : :https
    # image_tag asset_paths.compute_public_path(source, 'images', protocol: protocol), options
    # image_tag source, options
    image_tag asset_path(source, protocol: protocol), options
  end

end
