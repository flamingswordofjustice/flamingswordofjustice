class PolymorphicSelectInput < Formtastic::Inputs::SelectInput
  def select_html
    builder.select(input_name, polymorphic_collection, input_options, input_html_options)
  end

  def polymorphic_collection
    id = object.send(method)
    raw_collection.map do |o|
      selected = id.present? && o.id == id
      template.content_tag("option", :value => o.id, :selected => selected, :"data-type" => o.class.name) do
        o.send(option_label)
      end
    end.join.html_safe
  end

  def option_label
    options[:option_label]
  end

  def type_field
    field = options[:type_field] || input_name.to_s.gsub(/_id$/, '_type')
    builder_field_name_for field
  end

  def builder_field_name_for(field)
    field.present? ? "#{builder.object_name}[#{field}]" : nil
  end

  def input_html_options
    super.merge "data-target" => type_field
  end
end
