class RedirectsController < ApplicationController
  def index
    logger.info "No path given; redirecting to /"
    redirect_to root_path
  end

  def show
    redirect = Redirect.where(path: params[:id]).first

    if redirect.present?
      redirect.increment('hits').save
      Fsj.statsd.increment "redirects./#{params[:id]}"

      destination = redirect.destination
      destination += "?" + request.query_string unless request.query_string.blank?

      redirect_to destination
    else
      logger.error "Couldn't find a redirect for #{params[:id]}"
      redirect_to root_path
    end
  end
end
