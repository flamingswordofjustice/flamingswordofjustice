class ImageUploadInput < Formtastic::Inputs::FileInput
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper

  def to_html
    preview_type = self.options[:preview] || :thumb
    object = builder.object

    preview_image = if object.send(method).present?
      template.image_tag(object.send(method).send(preview_type).url)
    else nil end

    input_wrapping do
      label_html <<
      builder.file_field(method, input_html_options) <<
      template.content_tag(:p, preview_image, class: "inline-hints")
    end
  end
end
