module EmailsHelper

  def public_image_tag(source, options)
    protocol = Rails.env.development? ? :http : :https
    path = asset_path(source, protocol: protocol)

    if path =~ /^\/\//
      path = "#{protocol}:#{path}"
    end

    image_tag path.html_safe, options
  end

end
