class ReadonlyInput < Formtastic::Inputs::StringInput

  def to_html
    input_wrapping do
      label_html <<
      builder.hidden_field(method, value: value) <<
      template.content_tag("span", text)
    end
  end

  def value
    options[:value] || object.send(method)
  end

  def text
    options[:text] || options[:value] || object.send(method)
  end

end
