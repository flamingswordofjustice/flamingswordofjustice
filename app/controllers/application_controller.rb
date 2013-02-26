class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_nav_links

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def load_nav_links
    @nav_links = NavigationLink.root_links.order(:position).includes(:child_links, :page)
  end
end
