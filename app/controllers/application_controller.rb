class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_nav_links

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  private

  def render_error(status, exception)
    message = ([ exception.message ] + exception.backtrace).join("\n")
    logger.error message
    respond_to do |format|
      format.html { render template: "errors/#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def load_nav_links
    @nav_links = NavigationLink.root_links.order(:position).includes(:child_links, :linkable)
  end

  def touch_session
    session[:noop]; true # Read to force a session init.
  end

  private

  STANDARD = "s"
  ALTERNATE = "a"

  def choose_layout
    if ENV["RANDOMIZE_LAYOUT"]
      [STANDARD, ALTERNATE][ rand(2) ]
    else
      ALTERNATE
    end
  end

  def layout; params[:l]; end

end
