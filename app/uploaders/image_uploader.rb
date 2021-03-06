# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  if Rails.env.development? || Rails.env.test?
    storage :file
  else
    storage :fog
  end

  # Provide a default URL as a default if there hasn't been a file uploaded.
  def default_url
    image_path 'transparent.png'
  end

  # We won't need bigger, and this seems to be what Instagram/FB display.
  process resize_to_fit: [770,770]

  version :thumb do
    process resize_to_fill: [200,200]
  end

  version :logo do
    process resize_to_limit: [200,200]
  end

  version :social do
    process resize_to_fill: [403,403]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # We want a unique filename on each upload.
  # http://stackoverflow.com/a/5865117
  def filename
    if original_filename
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
  end

  def s3_headers
    { "Expires" => 1.year.from_how.httpdate }
  end
end
