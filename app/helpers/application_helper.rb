module ApplicationHelper
  def page_link_to(title, opts={})
    path = Page.where(title: title).first.try(:slug)
    link_to title, page || "#", opts
  end
end
