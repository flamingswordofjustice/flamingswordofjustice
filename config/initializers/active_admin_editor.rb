ActiveAdmin::Editor.configure do |config|
  # config.s3_bucket = ''
  # config.aws_access_key_id = ''
  # config.aws_access_secret = ''
  # config.storage_dir = 'uploads'

  config.parser_rules['tags']['iframe'] = {
    'remove' => 0,
    'check_attributes' => {
      'width' => 'numbers',
      'height' => 'numbers',
      'src' => 'url',
      'frameborder' => 'numbers',
      'allowfullscreen' => ''
    }
  }
  config.parser_rules['tags']['embed']  = { 'remove' => 0 }
end
