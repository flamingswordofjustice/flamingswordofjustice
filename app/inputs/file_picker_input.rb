class FilePickerInput < Formtastic::Inputs::FileInput
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper

  def to_html
    possible_images = ( object.send(method) || "" ).split(',')

    images_html = template.content_tag :ul, class: "thumbs" do
      possible_images.map do |i|
        template.content_tag :li do
          template.filepicker_image_tag(i, { w: 125, h: 125 }, { "data-src" => i }) +
          template.link_to(template.icon(:x), "#", class: "delete")
        end
      end.join.html_safe
    end

    input_wrapping do
      label_html <<
      builder.filepicker_field(method, self.options) <<
      images_html
    end
  end
end
